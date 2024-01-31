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
    puts "----------currency params---------"
    puts currency_params
    @currency = Currency.new(currency_params)
    source_currency = currency_params[:target_currency]
    target_currency = currency_params[:source_currency]
    exchange_rate = 1 / currency_params[:exchange_rate].to_f
    date = currency_params[:date]
    currency_2 = Currency.new(target_currency:target_currency,source_currency:source_currency,exchange_rate:exchange_rate,date:date)
    currency_2.save

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
    @source = source_currency
    @target = target_currency

    # ---same currency code will-- 
    # --always default to 1 as exchange rate--
    if target_currency == source_currency
      @result = amount 
      return @result, @source, @target
    end
    currency = Currency.find_by(source_currency:source_currency,target_currency:target_currency,date:date)
    if currency
      puts "--currency exists---"
      @result = amount / currency.exchange_rate
      @result = @result.round(2)
      return @result, @source, @target
    end

    # --otherwise: check if exchange rate --
    # --can be calculated based on -- 
    #  --the transit currency' : EUR --
    transit_currency = find_transit_currency(source_currency,target_currency,date)
    if !transit_currency
      raise 'Cannot be converted: no transit currency'
    end
    implicit_exchange_rate = calculate_implicit_exchange_rate(source_currency,target_currency,date,transit_currency)

    # checks if currency exists 
    # via implicit_exchange rate
    if implicit_exchange_rate
      puts "---implicit trigeered---"
      @result = amount * implicit_exchange_rate
      @result = @result.round(2)
    else
      raise 'Cannot be converted: values not found'
    end
    return @result, @source, @target
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

    def find_transit_currency(source_currency,target_currency,date)
      # find all currencies that have the mathcing params: source_currency, date
      # then for each of those currencies (tc_i) check if (target_currency,tc_i,date) exists and the instance it exists return tc_i
      currency_list = Currency.where(source_currency:source_currency,date:date)

      # -- if currency_list is empty --
      # -- return error since no matches -----
      if currency_list == []
        raise "Invalid date or currency"
      end

      # -- find transit currency ---
      # -- return it or nil if no match ----
      currency_list.each do |curr|
        target_source_ = curr.target_currency
        exists =  Currency.exists?(source_currency:target_currency, target_currency:target_source_,date:date)
        if exists
          return target_source_
        end
      end
      nil
    end

    def calculate_implicit_exchange_rate(source_currency,target_currency,date,transit_currency)
      # -- calculate source and target currency --
      # -- exchange rates to the transit currency --
      default_target = transit_currency
      currency1 = Currency.find_by(source_currency:source_currency,target_currency:default_target,date:date)
      currency2 = Currency.find_by(source_currency:target_currency,target_currency:default_target,date:date)

      #  -- raise exception when currency data doesn't exist --
      # -- otherwise return the calculated exchange_rate--

      if !currency1
        raise 'Currency1 data does not exist'
      elsif !currency2
        raise 'Currency2 data does not exist'
      else
        exchange_rate = currency2.exchange_rate / currency1.exchange_rate
        puts "---implicit exchange rate is #{exchange_rate}"
        return exchange_rate
      end
    end
end
