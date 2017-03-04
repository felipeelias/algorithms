module BFS
  class Edge
    class << self
      def [](*args)
        new(*args)
      end
    end

    attr_reader :parent, :child

    def initialize(parent, child, attributes = {})
      raise ArgumentError, "invalid :parent #{parent.inspect}" unless parent.is_a?(Node)
      raise ArgumentError, "invalid :child #{child.inspect}" unless child.is_a?(Node)

      @parent = parent
      @child = child
      @attributes = attributes
    end

    def fetch(*args)
      @attributes.fetch(*args)
    end
  end

  class Node
    class << self
      def [](*args)
        new(*args)
      end
    end

    attr_reader :id, :edges

    def initialize(id)
      @id = id
      @edges = {}
    end

    def each_edge
      edges.each do |_, multiple|
        multiple.each do |edge|
          yield edge, edge.child
        end
      end
    end

    def link(node, attributes = {})
      raise ArgumentError, "invalid :node #{node.inspect}" unless node.is_a?(Node)

      edges[node] ||= []
      edges[node] << Edge[self, node, attributes]
      self
    end
  end

  def search(start, finish)
    queue   = [start]
    visited = {start => true}
    path    = {}
    found   = false

    while queue.any? && !found
      current = queue.shift

      if current == finish
        found = true
        break
      end

      current.each_edge do |edge, node|
        if block_given?
          next if yield edge
        end

        if !visited[node]
          visited[node] = true
          path[node]    = current

          queue << node
        end
      end
    end

    found ? path : false
  end

  module_function :search
end
