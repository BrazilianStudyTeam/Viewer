# setting methods

$g_width
$g_height
$g_title
$g_fullscreen
$g_debug

def load_settings
	if File.exist? "settings.txt"
		if File.zero? "settings.txt"
			File.write "settings.txt", "g_width:800\ng_height:600\ng_title:BST Viewer\ng_fullscreen:false\ng_debug:false"
		else
			File.read("settings.txt").split("\n").each do |line|
				line.delete(' ').split(":").each_slice(2) do |xy|
					case xy.first
						when "g_width"
							$g_width = xy.last.to_i
						when "g_height"
							$g_height = xy.last.to_i
						when "g_title"
							$g_title = xy.last
						when "g_fullscreen"
							$g_fullscreen = xy.last.to_b
						when "g_debug"
							$g_debug = xy.last.to_b
					end
				end
			end
		end
	else
		File.write "settings.txt", "g_width:800\ng_height:600\ng_title:BST Viewer\ng_fullscreen:false\ng_debug:false"
	end
end

def check_settings
	valid_settings = if File.exist? "settings.txt"
						if File.zero? "settings.txt"
							File.write "settings.txt", "g_width:800\ng_height:600\ng_title:BST Viewer\ng_fullscreen:false\ng_debug:false"
							true
						else
							File.read("settings.txt").split("\n").each do |line|
								line.delete(' ').split(":").each_slice(2) do |xy|
									valid_settings = { g_width: 800, g_height: 600, g_fullscreen: false, g_title: "BST Viewer", g_debug: false}
									case xy.first
										when "g_width"
											if ((xy[1].to_i != nil) && (xy[1].to_i > 0))
												puts "width"
												valid_settings[:g_width] = xy[1].to_i
											end
										when "g_height"
											if ((xy[1].to_i != nil) && (xy[1].to_i > 0))
												puts "height"
												valid_settings[:g_height] = xy[1].to_i
											end
										when "g_title"
											if xy[1]!=nil
												puts "title"
												valid_settings[:g_title] = xy[1]
											end
										when "g_fullscreen"
											if (xy[1].respond_to?(:to_b)) && (xy[1].to_b!=nil)
												puts "full"
												valid_settings[:g_fullscreen] = xy[1].to_b
											end
										when "g_debug"
											if (xy[1].respond_to? :to_b) && (xy[1].to_b!=nil)
												puts "bega"
												valid_settings[:g_debug] = xy[1].to_b
											end
									end
								end
							end
							valid_settings
						end
					else
						File.write "settings.txt", "g_width:800\ng_height:600\ng_title:BST Viewer\ng_fullscreen:false\ng_debug:false"
						true
					end
	if (!valid_settings.is_boolean?)
		file = File.new("settings.txt", "w")
		valid_settings.keys.each do |key|
			file.write key.to_s+":"+valid_settings[key].to_s+"\n"
		end
		file.close unless file.closed?
	end
end