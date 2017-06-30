# name: gif-to-mp4
# about: This plugin converts .GIF images to .MP4.
# version: 0.1
# url: https://github.com/discourse/discourse-gif-to-mp4

after_initialize do

  DiscourseEvent.on(:upload) do |upload|
    if upload.filename[/\.gif$/i]
      tempfile = Tempfile.new(["video", ".mp4"])
      OptimizedImage.ensure_safe_paths!(upload.file.path, tempfile.path)

      Discourse::Utils.execute_command(
        'ffmpeg', '-y',
        '-f', 'gif',
        '-i', upload.file.path,
        tempfile.path
      )

      upload.file = tempfile
      upload.filename = (File.basename(upload.filename, ".*").presence || I18n.t("video").presence || "video") + ".mp4"
      upload.opts[:content_type] = "video/mp4"
    end
  end

end
