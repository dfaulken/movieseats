class VenuesController < ApplicationController
  before_action :set_venue, only: %i[ show edit update destroy update_seat test_solution ]

  # GET /venues or /venues.json
  def index
    @venues = Venue.all
  end

  # GET /venues/1 or /venues/1.json
  def show
  end

  # GET /venues/new
  def new
    @venue = Venue.new
  end

  # GET /venues/1/edit
  def edit
  end

  # POST /venues or /venues.json
  def create
    @venue = Venue.new(venue_params)

    respond_to do |format|
      if @venue.save
        format.html { redirect_to @venue, notice: "Venue was successfully created." }
        format.json { render :show, status: :created, location: @venue }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /venues/1 or /venues/1.json
  def update
    respond_to do |format|
      if @venue.update(venue_params)
        format.html { redirect_to @venue, notice: "Venue was successfully updated." }
        format.json { render :show, status: :ok, location: @venue }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @venue.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /venues/1 or /venues/1.json
  def destroy
    @venue.destroy
    respond_to do |format|
      format.html { redirect_to venues_url, notice: "Venue was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update_seat
    seat_params = params.require(:seat).permit(:id, :available)
    @seat = @venue.seats.find(seat_params[:id])
    if @seat && @seat.update(available: seat_params[:available])
      redirect_to @venue, notice: 'Seat updated.'
    else redirect_to @venue, notice: 'Seat update failed.'
    end
  end

  def test_solution
    if request.post?
      solver = MovieSeatsSolver.new
      solver.input_data = JSON.parse(solution_params[:input_data])
      solver.parse_input_data!
      solver.requested_group_size = solution_params[:requested_group_size].to_i
      solver.solve!
      render json: solver.solution_json_data, status: :ok
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_venue
      @venue = Venue.includes(:seats).find(params[:id])
    end

    def solution_params
      params.require(:venue).permit(:input_data, :requested_group_size)
    end

    # Only allow a list of trusted parameters through.
    def venue_params
      params.require(:venue).permit(:rows, :columns)
    end
end
