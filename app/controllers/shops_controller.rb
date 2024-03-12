class ShopsController < ApplicationController
  def index
    # TODO:
    # - venir find l'history quand tout sera correctement connecté
    # - remplacer Shop.all par une recherche en fonction du product alternative sélectionné
    @product_alternative = ProductAlternative.find(params[:product_alternative_id])
    @history = History.find_by(user: current_user, scanned_product_alternative: @product_alternative)
    # @history.update!(product_alternative: ProductAlternative.find(params[:product_alternative_id]))
    @shops = @product_alternative.shops
    @markers = @shops.geocoded.map do |shop|
      {
        lat: shop.latitude,
        lng: shop.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: { shop: shop }),
        marker_html: render_to_string(partial: "marker", locals: {shop: shop}),
      }
    end
    @options = {
      # [lng, lat]
      center: [2.33333, 48.866667],
      # zoom: 15,
      class: "h-100 w-100",
      token: ENV['MAPBOX_API_KEY'],
      markers: @markers
    }
  end

  def show
    # TODO: venir find l'history quand tout sera correctement connecté
    @shop = Shop.find(params[:id])
    @history_id = session[:last_history_id] || History.last.id
    @is_shop_open = shop_open_now?(@shop.opening_hours)
  end

  def itinerary
    # TODO: venir find l'history quand tout sera correctement connecté
    @shop = Shop.find(params[:id])
    @history = History.find(params[:history_id])
    @history.update(shop: @shop)
    history_loc = [@history.lng, @history.lat]
    @options = {
      # [lng, lat]
      center: history_loc,
      zoom: 15,
      class: "h-100 w-100",
      token: ENV['MAPBOX_API_KEY'],
      path: "cycling",
      path_options: {
        line_color: "#000",
        # line_width: 2
      },
      markers: [
        history_loc,
        [@shop.longitude, @shop.latitude]
      ]
    }
  end

  # Method to check if the shop is open
  def shop_open_now?(opening_hours)
    # current_time = Time.now
    # opening_hours.each do |day, hours|
    #   if hours.present? && hours["open"].present? && hours["close"].present?
    #     open_time = Time.parse(hours["open"])
    #     close_time = Time.parse(hours["close"])
    #     return true if current_time >= open_time && current_time <= close_time
    #   end
    # end
    false
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_shop
    @shop = Shop.find(params[:id])
  end
end
