require 'nokogiri'
require 'open-uri'
require 'csv'
class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  def scrape
    url = "https://www.scrapethissite.com/pages/forms/?per_page=100"
    doc = Nokogiri::HTML5(URI.open(url))

    teams = {}
    #data = Hash.new

    doc.css("tr.team").each do |team|
      team_name = team.at(".name").inner_text.strip
      team_wins = team.at(".wins").inner_text.to_i
      # team_losses = team.at(".losses").inner_text.to_i
      # team_match_year = team.at(".year").inner_text.strip
      # data[team_name] = {"wins" => "#{team_wins}", "looses" => "#{team_losses}", "year" => "#{team_match_year}"}
      teams[team_name] ||= 0
      teams[team_name] += team_wins
      # teams[team_name] += team_losses
    end
    # teams.each do |team_name, team_wins|
    #   puts "#{team_name} => #{team_wins}"
    # end
    # data.each do |key, value|
    #   puts "#{key} => #{value}"
    #   value.each do |val|
    #     puts "#{key} => #{value}"
    #   end
    # end
    CSV.open("/home/file.csv", "a+") do |csv|
      csv << ["team name", "team wins"]
      teams.each do |team_name, team_wins|
        csv << ["#{team_name}", "#{team_wins}"]
      end
    end
    if response[:status] == :completed && response[:error].nil?
      flash.now[:notice] = "Successfully scraped url"
    else
      flash.now[:alert] = response[:error]
    end
  rescue StandardError => e
    flash.now[:alert] = "Error: #{e}"
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post), notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :body)
    end
end
