module Mongoid
  ##
  # = Mongoid::Orderable
  #
  # == Utility methods
  #
  # There are several methods to move nodes around in the list:
  #
  #    node.move_up
  #    node.move_down
  #    node.move_to_top
  #    node.move_to_bottom
  #    node.move_above(other)
  #    node.move_below(other)
  #
  # Additionally there are some methods to check aspects of the document
  # in the list of children:
  #
  #    node.at_top?
  #    node.at_bottom?
  module Orderable
    extend ActiveSupport::Concern

    included do
      field :position, :type => Integer

      default_scope asc(:position)
      
      before_save :assign_default_position
      after_destroy :move_lower_siblings_up
    end

    ##
    # Returns siblings below the current document.
    # Siblings with a position greater than this documents's position.
    def lower_siblings
      self.class.where(:position.gt => self.position)
    end

    ##
    # Returns siblings above the current document.
    # Siblings with a position lower than this documents's position.
    def higher_siblings
      self.class.where(:position.lt => self.position)
    end

    ##
    # Returns the lowest sibling (could be self)
    def last_sibling_in_list
      self.class.asc(:position).last
    end

    ##
    # Returns the highest sibling (could be self)
    def first_sibling_in_list
      self.class.asc(:position).first
    end

    ##
    # Is this the highest sibling?
    def at_top?
      higher_siblings.empty?
    end

    ##
    # Is this the lowest sibling?
    def at_bottom?
      lower_siblings.empty?
    end

    ##
    # Move this node above all its siblings
    def move_to_top
      return true if at_top?
      move_above(first_sibling_in_list)
    end

    ##
    # Move this node below all its siblings
    def move_to_bottom
      return true if at_bottom?
      move_below(last_sibling_in_list)
    end

    ##
    # Move this node one position up
    def move_up
      return if at_top?
      self.class.where(:position => self.position - 1).first.inc(:position, 1)
      inc(:position, -1)
    end

    ##
    # Move this node one position down
    def move_down
      return if at_bottom?
      self.class.where(:position => self.position + 1).first.inc(:position, -1)
      inc(:position, 1)
    end

    ##
    # Move this node above the specified node
    #
    # This method changes the node's parent if nescessary.
    def move_above(other)
      if position > other.position
        new_position = other.position
        other.lower_siblings.where(:position.lt => self.position).each { |s| s.inc(:position, 1) }
        other.inc(:position, 1)
        self.position = new_position
        save!
      else
        new_position = other.position - 1
        other.higher_siblings.where(:position.gt => self.position).each { |s| s.inc(:position, -1) }
        self.position = new_position
        save!
      end
    end

    ##
    # Move this node below the specified node
    #
    # This method changes the node's parent if nescessary.
    def move_below(other)
      if position > other.position
        new_position = other.position + 1
        other.lower_siblings.where(:position.lt => self.position).each { |s| s.inc(:position, 1) }
        self.position = new_position
        save!
      else
        new_position = other.position
        other.higher_siblings.where(:position.gt => self.position).each { |s| s.inc(:position, -1) }
        other.inc(:position, -1)
        self.position = new_position
        save!
      end
    end

    private

      def move_lower_siblings_up
        lower_siblings.each { |s| s.inc(:position, -1) }
      end

      def assign_default_position
        return unless self.position.nil?

        if self.class.all.empty? || self.class.all.collect(&:position).compact.empty?
          self.position = 0
        else
          self.position = self.class.max(:position) + 1
        end
      end
  end
end
