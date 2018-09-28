class MoviesController < ApplicationController
  # attr_accessor :a
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
    
    @all_ratings = Movie.get_valid_ratings
    @movies = Movie.all
    
    #If change in selection except no selection, update session data
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end
    #Flow first time when session data is nil
    if !session[:ratings] 
      session[:ratings]= Hash[@all_ratings.collect { |item| [item, 1] } ]
    end
    #If change in sorting, update session data
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    
    #Sorting+filtering
    @movies = Movie.order(session[:sort_by]).where(rating: session[:ratings].keys)
    
    #If either params rating or sort is nil i.e. different from session, update
    #with data from session
    if session[:ratings] != params[:ratings] || session[:sort] != params[:sort]
      redirect_to movies_path(ratings: session[:ratings], sort: session[:sort])
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
