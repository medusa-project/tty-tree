# encoding: utf-8
# frozen_string_literal: true

module TTY
  class Tree
    # Render nodes as files paths explorer
    class DirectoryRenderer
      MARKERS = {
        unicode: {
          branch: '├──',
          leaf: '└──',
          pipe: '│',
          file_pipe: '|  '
        },
        ansi: {
          branch: '|--',
          leaf: '`--',
          pipe: '|'
        }
      }.freeze

      def initialize(nodes, options = {})
        @nodes  = nodes
        @indent = options.fetch(:indent, 4)
        @pipe_mark  = MARKERS[:unicode][:pipe] + ' ' * [@indent - 1, 0].max
        @space_mark = ' ' * @indent
      end

      def render
        @nodes.reduce([]) do |acc, node|
          render_node(acc, node, @pipe_mark, @space_mark)
        end.join('')
      end

      private

      def render_node(acc, node, pipe_mark, space_mark)
        acc << node.prefix.gsub(/:pipe/, pipe_mark).gsub(/:space/, space_mark)
        unless node.root?
          acc << MARKERS[:unicode][node_prefix(node)]
          acc << ' '
        end
        acc << node.name.to_s + "\n"
      end

      def node_prefix(node)
        #return :file_pipe if node.is_file
        node.leaf? ? :leaf : :branch
      end
      
    end # DirRenderer
  end # Tree
end # TTY
