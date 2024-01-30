class CurrenciesController < ApplicationController
  before_action :set_currency, only: %i[ show edit update destroy ]

  # GET /currencies or /currencies.json
  def index
    @currencies = Currency.all
  end

  # GET /currencies/1 or /currencies/1.json
  def show
  end

  # GET /currencies/new
  def new
    @currency = Currency.new
  end

  # GET /currencies/1/edit
  def edit
  end

  # POST /currencies or /currencies.json
  def create
    @currency = Currency.new(currency_params)

    respond_to do |format|
      if @currency.save
        format.html { redirect_to currency_url(@currency), notice: "Currency was successfully created." }
        format.json { render :show, status: :created, location: @currency }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /currencies/1 or /currencies/1.json
  def update
    respond_to do |format|
      if @currency.update(currency_params)
        format.html { redirect_to currency_url(@currency), notice: "Currency was successfully updated." }
        format.json { render :show, status: :ok, location: @currency }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @currency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1 or /currencies/1.json
  def destroy
    @currency.destroy!

    respond_to do |format|
      format.html { redirect_to currencies_url, notice: "Currency was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # def info_retrieval
    
  # end

  def result
    # puts "----------triggered---------"
    source_currency = params[:currency]
    target_currency = params[:currency2]
    date = params[:date]
    amount = params[:amount].to_f

    # ---same currency code will-- 
    # --always default to 1 as exchange rate--
    if target_currency == source_currency
      @result = amount 
      return @result
    end

    currency = Currency.find_by(source_currency:source_currency,target_currency:target_currency,date:date)

    # ---transit currency right now ---
    # ---is set by default to EUR but add on views side---
    implicit_exchange_rate = calculate_implicit_exchange_rate(source_currency,target_currency,date,"EUR")
    # checks if currency exists
    if currency
      puts "--currency exists---"
      @result = amount / currency.exchange_rate
      @result = @result.round(2)
    
    # --otherwise checks if exchange rate --
    # --can be calculated based on-- 
    #  --the transit currency' : EUR--

    elsif implicit_exchange_rate
      puts "---implicit trigeered---"
      @result = amount * implicit_exchange_rate
      @result = @result.round(2)
    else
      raise 'Values not found'
    end
    @result
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_currency
      @currency = Currency.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def currency_params
      params.require(:currency).permit(:source_currency, :target_currency, :exchange_rate, :date)
    end

    def calculate_implicit_exchange_rate(source_currency,target_currency,date,transit_currency)
      default_target = transit_currency
      currency1 = Currency.find_by(source_currency:source_currency,target_currency:default_target,date:date)
      currency2 = Currency.find_by(source_currency:target_currency,target_currency:default_target,date:date)
      if !currency1 or !currency2
        raise 'Currency1 data does not exist'
      elsif !currency2
        raise 'Currency2 data does not exist'
      else
        exchange_rate = currency2.exchange_rate / currency1.exchange_rate
        puts "---implicit exchange rate is #{exchange_rate}"
        exchange_rate
      end
    end
end
