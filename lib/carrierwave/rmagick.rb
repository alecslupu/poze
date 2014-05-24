module CarrierWave
  module RMagick

    # Rotates the image based on the EXIF Orientation
    def fix_exif_rotation
      manipulate! do |img|
        img.auto_orient!
        img = yield(img) if block_given?
        img
      end
    end

    # Strips out all embedded information from the image
    def strip
      manipulate! do |img|
        img.strip!
        img = yield(img) if block_given?
        img
      end
    end

    # Reduces the quality of the image to the percentage given
    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage }
        img = yield(img) if block_given?
        img
      end
    end

    def resize_to_fill_if_larger(width, height, gravity=::Magick::CenterGravity)
      geometry = get_geometry
      if geometry.first>width && geometry.last > height
        manipulate! do |img|
          img.crop_resized!(width, height, gravity)
          img = yield(img) if block_given?
          img
        end
      end
    end

    def get_geometry
      img = ::Magick::Image::read(current_path).first
      geometry = [ img.columns, img.rows ]
    end

    module ClassMethods
      def resize_to_fill_if_larger(width, height, gravity=::Magick::CenterGravity)
        process :resize_to_fill_if_larger => [width, height]
      end
    end

    def watermark
      manipulate! do |img|
        # We draw a square to put the watermark, and we are using
        # Pitagora's theorem to determine the width
        width  = Math.sqrt(img.columns**2 + img.rows**2);
        mark = ::Magick::Image.new(width, width)
        gc = ::Magick::Draw.new
        gc.gravity = ::Magick::CenterGravity
        gc.pointsize = (img.columns / 15).to_i
        gc.font = "#{Rails.root}/app/assets/fonts/TitilliumWeb-ExtraLight.ttf"
        gc.stroke = "none"
        gc.text_antialias = true
        gc.annotate(mark, 0, 0, 0, 0, "Copyright")


        # very ugly lines :(
        #gc = Magick::Draw.new
        #steps = (width**2 / 100).to_i
        #
        #for i in (1..steps)
        #  distance = i*50
        #  gc.line(0,distance,   width, distance)
        #  gc.line(distance, 0,  distance, width)
        #end
        #
        #gc.stroke 'black'
        #gc.stroke_antialias false
        #gc.opacity('20%')
        #gc.stroke_opacity('20%')
        #gc.stroke_width(0)
        #gc.draw(mark)

        mark.rotate!(-45)
        mark = mark.shade(true, 90, 30)
        img.composite!(mark, ::Magick::CenterGravity, ::Magick::HardLightCompositeOp)
        img
      end
    end
  end
end
