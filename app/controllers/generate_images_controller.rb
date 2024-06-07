require "rmagick"

class GenerateImagesController < ApplicationController
  def generate
    img = Magick::Image.new(300, 200) do |i|
        i.background_color = 'red'
    end

    # draw text
    draw = Magick::Draw.new
    draw.font = 'Helvetica'
    draw.pointsize = 25
    draw.gravity = Magick::CenterGravity

    # Annotate the image with the first line of text in the center
    draw.annotate(img, 0, 0, 0, -40, "Hello, World!") do |txt|
      txt.fill = 'white'
    end

    draw.annotate(img, 0, 0, 0, 0, "This is a second line.") do |txt|
      txt.fill = 'white'
    end

    draw.annotate(img, 0, 0, 0, 40, "And a third line here.") do |txt|
      txt.fill = 'white'
    end

    # Save the image to the public images directory
    img.write(Rails.root.join('public', 'images', 'hello_world.jpg'))

    redirect_to action: :show_image
  end

  def show_image
    render 'show_image'
  end
end
