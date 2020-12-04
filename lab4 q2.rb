module Resource
  def connection(routes)
    if routes.nil?
      puts "No route matches for #{self}"
      return
    end

    loop do
      print 'Choose verb to interact with resources (GET/POST/PUT/DELETE) / q to exit: '
      verb = gets.chomp
      break if verb == 'q'

      action = nil

      if verb == 'GET'
        print 'Choose action (index/show) / q to exit: '
        action = gets.chomp
        break if action == 'q'
      end


      action.nil? ? routes[verb].call : routes[verb][action].call
    end
  end
end

class PostsController
  extend Resource
  def initialize
    @posts = []
  end

  def index
    if @posts.empty? 
      puts 'No post found'
      return
    end
    @posts.each.with_index{ |value, key| 
      puts "index: #{key} value: #{value}"
    }
  end

  def show
    puts 'show'
    loop do
      print 'enter post id: ' 
      i_post = gets.to_i
      if @posts.size > i_post && (i_post >= 0)
        puts "Post with id #{i_post}\n#{@posts[i_post]}"
        break
      end
      if i_post == -1
        break
      end
      puts "Error! Post with id #{i_post} not found\nTry again or -1 for exit" 
    end
  end

  def create
    loop do
      puts "create\nEnter your post:"
      p_text = gets
      if p_text.size > 1
        @posts.push(p_text)
        break
      end
      puts "You not input a comment! Try again"
    end
  end

  def update
    puts 'update'
    print 'input post id: '
    i_post = gets.to_i
    i_data = nil
    loop do
      puts 'Enter your post:'
      i_data = gets
      if !i_data.empty?
        break
      end
      puts "You not input comment! Try again"
    end
    @posts[i_post] = i_data
    self.index
  end

  def destroy
    puts 'destroy'
    loop do
      print 'input post id or -1 for exit: '
      i_post = gets.to_i
      if i_post == -1 
        break 
      end
      if @posts.size > i_post
        @posts.delete_at(i_post)
        return
      else puts "This post not exist\n Enter equal post id or -1"
      end
    end
  end
end

class CommentsController
  extend Resource
  def initialize
      @comments = {} # Ключом будет id от поста, а массив комментов - собственно коммы
  end

  def index
      if @comments.empty? 
          puts 'Comments not found'
          return
      end
      @comments.each{ |key, value|
          puts "post id: #{key}\n"
          value.each.with_index {|vl, i|
            puts "id comment: #{i} comment text: #{vl}"
          }
      }
  end

  def show
    print 'Input post id: '
    id_post = gets.to_i
    if @comments.key?(id_post)
      @comments[id_post].each.with_index{|value, id|
          puts "comment id: #{id} comment text: #{value}"
      }
    else puts "No comments found"
    end
  end

  def create
    print 'Input post id: '
    id_post = gets.to_i
    puts "input comment: "
    comment_text = gets
    @comments.store(id_post, [comment_text])
  end

  def update
    print 'Input post id: '
    id_post = gets.to_i
    puts "Input comment:"
    comment_text = gets
    if @comments.key?(id_post)
      @comments[id_post].push(comment_text)
    else 
      @comments.store(id_post, [comment_text])
    end
    self.index
  end

  def destroy
    print 'Input post id: '
    id_post = gets.to_i
    @comments.delete(id_post)
  end
end

class Router
  def initialize
    @routes = {}
  end

  def init
    resources(PostsController, 'posts')
    resources(CommentsController, 'comments')
    loop do
      print 'Choose resource you want to interact (1 - Posts, 2 - Comments, q - Exit): '
      choise = gets.chomp

      PostsController.connection(@routes['posts']) if choise == '1'
      CommentsController.connection(@routes['comments']) if choise == '2'
      break if choise == 'q'
    end

    puts 'Good bye!'
  end

  def resources(klass, keyword)
    controller = klass.new
    @routes[keyword] = {
      'GET' => {
        'index' => controller.method(:index),
        'show' => controller.method(:show)
      },
      'POST' => controller.method(:create),
      'PUT' => controller.method(:update),
      'DELETE' => controller.method(:destroy)
    }
  end
end
