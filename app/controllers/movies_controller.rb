class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @sort=params[:sort]
    @movies=Movie.order(params[:sort])
    @all_ratings=['G','PG','PG-13','R']
    @filter_ratings=[]
    @filter_ratings_h={}

    if(params[:sort])
      session[:sort]=@sort
    else if(session[:sort])
           params[:sort]=session[:sort]
           @sort=params[:sort]
         end
    end

    if (params[:ratings])
      params[:ratings].each_key do |key|
        @filter_ratings_h[key]=key
        @filter_ratings.push(key)
      end
      @movies = Movie.find(:all, :order=>@sort, :conditions => {:rating => @filter_ratings})
      session[:ratings] = @filter_ratings_h;
    else if (session[:ratings])
           flash.keep
        redirect_to movies_path(:sort=>session[:sort], :ratings=>session[:ratings])
      end
      @movies = Movie.all(:order=>@sort)
    end

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
