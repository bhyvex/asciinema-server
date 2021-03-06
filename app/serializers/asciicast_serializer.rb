class AsciicastSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :url, :snapshot, :width, :height

  delegate :private?, :title, :ready?, to: :object

  def id
    object.to_param
  end

  def url
    if v0_url?
      object.stdout_frames_url
    else
      if url = object.data.url
        if url.starts_with?("/")
          asciicast_path(object, format: :json) # download URL for local carrierwave store
        else
          url # direct signed S3 URL (because XHR CORS redirect doesn't work under Safari)
        end
      end
    end
  end

  def author_display_name
    object.user.display_name
  end

  def author_url
    object.user.url
  end

  def author_avatar_url
    object.user.avatar_url(object.user)
  end

  private

  def v0_url?
    !!@options[:v0]
  end

end
