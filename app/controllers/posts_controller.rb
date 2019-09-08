class PostsController < ApplicationController
    before_action :valid_user, only: [:new, :create]
    before_action :not_bob,    only: [:create]
    
    def new
        @post = Post.new
    end

    def create
        @post = Post.new(post_params)
        @post.user_id = current_user.id
        if @post.save
            flash[:success] = "Successfully posted!"
            redirect_to root_url
        else
            render 'new'
        end
    end

    def index
        @posts = Post.paginate(page: params[:page])
    end

    private

        def post_params
            params.require(:post).permit(:title, :body)
        end

        def valid_user
            if !logged_in?
                flash[:warning] = "You must be logged in to do that."
                redirect_to root_url
            end
        end

        def not_bob
            if current_user.email.downcase == "bob@foobar.com"
                flash[:info] = "This user cannot make new posts"
                redirect_to new_post_url
            end
        end
end
