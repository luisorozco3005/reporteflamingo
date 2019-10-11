class OrdersController < ApplicationController

  def create


    information = request.raw_post
    ordenservicio = JSON.parse(information)

    ordenservicio = Orden.new

    ordenservicio.from_json(information)
    ordenservicio.print
    render json: ordenservicio.items
  end





end


