require 'tk'
require_relative 'scripts/user_management'
require_relative 'scripts/css_management'
class Controller
    def initialize

        #class variable definitions


        #did a ton of colors, didnt have the patience for a ton of fonts.
        @default_colors = 'AliceBlue', 'AntiqueWhite', 'Aqua', 'Aquamarine', 'Azure',
                          'Beige', 'Bisque', 'Black', 'BlanchedAlmond', 'Blue', 'BlueViolet',
                          'Brown', 'BurlyWood', 'CadetBlue', 'Chartreuse', 'Chocolate',
                          'Coral', 'CornflowerBlue', 'Corensilk', 'Crimson', 'Cyan', 'DarkBlue',
                          'DarkCyan', 'DarkGoldenRod', 'DarkGray', 'DarkGreen', 'GarkKhaki', 'DarkMagenta',
                          'DarkOliveGreen', 'DarkOrange', 'DarkOrchid', 'DarkRed', 'DarkSalmon', 'DarkSeaGreen',
                          'DarkSlateBlue', 'DarkSlateGray', 'DarkTurqoise', 'DarkViolet', 'DeepPink',
                          'DeepSkyBlue', 'DimGray', 'DodgerBlue', 'FireBrick', 'FloralWhite', 'ForestGreen',
                          'Fuchsia', 'Gainsboro', 'GhostWhite', 'Gold', 'GoldenRod', 'Gray', 'Green',
                          'GreenYellow', 'HoneyDew', 'HotPink', 'IndianRed', 'Indigo', 'Ivory',
                          'Khaki', 'Lavender', 'LavenderBlush', 'LawnGreen', 'LemonChiffon', 'LightBlue',
                          'LightCoral', 'LightCyan', 'LightGoldenRodYellow', 'LightGrey', 'LightGreen',
                          'LightPink', 'LightSalmon', 'LightSeaGreen', 'LightSkyBlue', 'LightSlateGrey',
                          'LightSteelBlue', 'LightYellow', 'Lime', 'LimeGreen', 'Linen', 'Magenta',
                          'Maroon', 'MediumAquaMarine', 'MediumBlue', 'MediumOrchid', 'MediumPurple',
                          'MediumSeaGreen', 'MediumSlateBlue', 'MediumSpringGreen', 'MediumTurquoise',
                          'MediumVioletRed', 'MidnightBlue', 'MintCream', 'MistyRose', 'Moccasin',
                          'NavajoWhite', 'Navy', 'OldLace', 'Olive', 'OliveDrab', 'Orange', 'OrangeRed',
                          'Orchid', 'PaleGoldenRod', 'PaleGreen', 'PaleTurqoise', 'PaleVioletRed', 'PapayaWhip',
                          'PeachPuff', 'Peru', 'Pink', 'Plum', 'PowderBlue', 'Purple' 'RebeccuPurple',
                          'Red', 'RosyBrown', 'RoyalBlue', 'SaddleBrown', 'Salmon', 'SandyBrown', 'SeaGreen',
                          'SeaShell', 'Sienna', 'Silver', 'SkyBlue', 'SlateBlue', 'SlateGrey', 'Snow', 'SpringGreen',
                          'SteelBlue', 'Tan', 'Teal', 'Thistle', 'Tomato', 'Turqoise', 'Violet', 'Wheat', 'White', 'WhiteSmoke',
                          'Yellow', 'YellowGreen'

        @default_fonts = 'serif', 'sans-serif', '"Avro", serif',
                         '"Ubuntu", sans-serif', '"Arial", sans-serif',
                         '"Helvetica", sans-serif', '"Times New Roman", serif',
                         '"Courier New", serif', '"Courier", serif',
                         '"Verdana", sans-serif', '"Georgia", serif',
                         '"Palatino", serif', '"Garamond", serif',
                         '"Bookman", serif', '"Comic Sans MS" sans-serif',
                         '"Trebuchet MS", sans-serif', '"Arial Black", sans-serif',
                         '"Impact", sans-serif'

        @defualt_text_sizes = '4', '6', '8', '10', '12', '14', '16', '18', '20', '24', '36', '48', '64'
        @password_valid = false, false
        @username_valid = false, false
        @user_manager = UserManagement.new
        @css_manager = CssCreator.new
        @windowid = 0
        @alert = []

        #Button stuff
        #there's a lot

        def alert(window_message, text_message)
            windowid = @windowid + 1
            @alert[windowid] = TkToplevel.new(@root) do
                title "#{window_message}"
            end
            alert_frame = TkFrame.new(@alert[windowid]) do
                pack(padx: 10, pady: 10)
            end
            TkLabel.new(alert_frame) do
                width 25
                text "#{text_message}"
                pack(side: 'top', padx: 5, pady: 5, fill: 'y')
            end
        end
        
        def validate_color(color)
            color = color.to_s
            color = color.strip()
            valid = false
            @default_colors.each do |d_color|
                if d_color.to_s == color
                    valid = true
                end
            end
            unless valid
                valid = !!color.match(/\A#(\h{3}){1,2}\z/)
            end
            valid
        end

        def validate_size(size)
            size = size.to_s
            size = size.strip()
            valid = !!size.match(/\A[0-9]\z/)
            valid
        end

        

        save_alert_destroy = proc do
            @save_alert.destroy
        end

        user_save_button_clicked = proc do
            if @user_selector_combobox.value == "New User" && @username_valid[1] && @password_valid[1]
                @user_manager.MakeUser("#{@username_textentry.value}", "#{@password_textentry.value}")
                alert("Successes", "User was successfully saved")
            elsif @username_valid[0] && @password_valid[0]
                @user_manager.ModifyUser("#{@user_selector_combobox.value}","#{@username_textentry.value}", "#{@password_textentry}" )
                alert("Successes", "User was successfully saved")
            else
                alert("Failure", "Could not make user")
            end
            @user_selector_combobox.values = @user_manager.GetUsernames().unshift('New User');
        end

        user_delete_button_clicked = proc do
            unless @user_selector_combobox.value == "New User"
                @user_manager.RemoveUser("#{@user_selector_combobox.value}")
                alert("Success", "Successfully removed user")
                @user_selector_combobox.value = "New User"
            else
                alert("Failure", "Could not remove user")
            end
            @user_selector_combobox.values = @user_manager.GetUsernames().unshift('New User');
        end

        background_color_save_button_clicked = proc do
            if validate_color("#{@background_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@background_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        foreground_color_save_button_clicked = proc do
            if validate_color("#{@foreground_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@foreground_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        header_color_save_button_clicked = proc do
            if validate_color("#{@header_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@header_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        navbar_color_save_button_clicked = proc do
            if validate_color("#{@navbar_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@navbar_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        header_text_color_save_button_clicked = proc do
            if validate_color("#{@header_text_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@header_text_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        header_text_font_save_button_clicked = proc do
            @css_manager.ChangeOption([1,3,"font-family:#{@header_text_font_combobox.value.to_s}"])
        end

        header_text_size_save_button_clicked = proc do
            if validate_size("#{@header_text_size_combobox.value.to_s}")
                @css_manager.ChangeOption([1,4,"font-size:#{@header_text_size_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Size")
            end
        end

        navbar_text_color_save_button_clicked = proc do
            if validate_color("#{@navbar_text_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@navbar_text_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        navbar_text_font_save_button_clicked = proc do
            @css_manager.ChangeOption([2,3,"font-family:#{@navbar_text_font_combobox.value.to_s}"])
        end

        navbar_text_size_save_button_clicked = proc do
            if validate_size("#{@navbar_text_size_combobox.value.to_s}")
                @css_manager.ChangeOption([2,4,"font-size:#{@navbar_text_size_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Size")
            end
        end

        body_text_color_save_button_clicked = proc do
            if validate_color("#{@body_text_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@body_text_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        body_text_font_save_button_clicked = proc do
            @css_manager.ChangeOption([3,3,"font-family:#{@body_text_font_combobox.value.to_s}"])
        end

        body_text_size_save_button_clicked = proc do
            if validate_size("#{@body_text_size_combobox.value.to_s}")
                @css_manager.ChangeOption([3,4,"font-size:#{@body_text_size_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Size")
            end
        end

        link_text_color_save_button_clicked = proc do
            if validate_color("#{@link_text_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@link_text_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        link_text_font_save_button_clicked = proc do
            @css_manager.ChangeOption([4,3,"font-family:#{@link_text_font_combobox.value.to_s}"])
        end

        link_text_size_save_button_clicked = proc do
            if validate_size("#{@link_text_size_combobox.value.to_s}")
                @css_manager.ChangeOption([4,4,"font-size:#{@link_text_size_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Size")
            end
        end

        usedlink_text_color_save_button_clicked = proc do
            if validate_color("#{@usedlink_text_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@usedlink_text_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        usedlink_text_font_save_button_clicked = proc do
            @css_manager.ChangeOption([5,3,"font-family:#{@usedlink_text_font_combobox.value.to_s}"])
        end

        usedlink_text_size_save_button_clicked = proc do
            if validate_color("#{@usedlink_text_size_combobox.value.to_s}")
                @css_manager.ChangeOption([5,4,"font-size:#{@usedlink_text_size_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Size")
            end
        end

        footer_text_color_save_button_clicked = proc do
            if validate_color("#{@footer_text_color_combobox.value.to_s}")
                @css_manager.ChangeOption([0,1,"background-color:#{@footer_text_color_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Color")
            end
        end

        footer_text_font_save_button_clicked = proc do
            @css_manager.ChangeOption([6,3,"font-family:#{@footer_text_font_combobox.value.to_s}"])
        end

        footer_text_size_save_button_clicked = proc do
            if validate_size("#{@footer_text_size_combobox.value.to_s}")
                @css_manager.ChangeOption([6,4,"font-size:#{@footer_text_size_combobox.value.to_s}"])
            else
                alert("ERROR", "Invalid Size")
            end
        end

        css_load_button_clicked = proc do
            @css_text_box.value = @css_manager.GetCss()
        end

        css_save_button_clicked = proc do
            @css_manager.SaveCssEdit(@css_text_box.value)
        end

        backup_location_save_button_cliked = proc do
            alert("Backup Location Message","You changed the Location!\nBut it doesn't do anything.\nServer backups are not ready.")
        end

        backup_server_button_clicked = proc do
            alert("Backup Server Message","Backup Server Clicked!\nTo be added later.\n Sinatra doesn't play nice")
        end

        load_server_backup_button_clicked = proc do
            alert("Load Backup Message","Load Server Backup Clicked!\nTo be added later.\n Sinatra doesn't play nice")
        end

        start_server_button_clicked = proc do
            alert("Start Server Message","Start Server Clicked!\nTo be added later.\n Sinatra doesn't play nice")
        end

        stop_server_button_clicked = proc do
            alert("Stop Server Message","Stop Server Clicked!\nTo be added later.\n Sinatra doesn't play nice")

        end

        #design stuff

        #gets called to update the user selection label
        update_user_selection = proc do
            @username_label.text = "You are modifying: #{@user_selector_combobox.value}"
            @username_textentry.value = @user_selector_combobox.value 
        end

        #validates the username and password
        username_alert_destroy = proc do
            @username_alert.destroy
        end

        username_validation = proc do
            username = @username_textentry.value.to_s
            @username_valid[0] = !!username.match(/\A[a-z]+\Z/i) && (username.length > 1 || username.length == 0)
            @username_valid[1] = !!username.match(/\A[a-z]+\Z/i) && username.length > 1
            unless @username_valid[0]
                alert("Error", "Username not valid\nUsername must contain letters only\nUsername must be at least 2 characters long")
            end
        end

        password_alert_destroy = proc do
            @password_alert.destroy
        end

        password_validation = proc do
            password = @password_textentry.value.to_s
            @password_valid[0] = !!password.match(/\A[a-z ]+\Z/i) && ((password.length >= 16 && password.length <= 128) || password.length == 0)
            @password_valid[1] = !!password.match(/\A[a-z ]+\Z/i) && password.length >= 16 && password.length <= 128
            unless @password_valid[0]
                alert("ERROR", "Password not valid.\nPassword must contain letters and spaces only\nPassword must be between 16-128 characters")
            end
        end
        

        #root for the window
        @root = TkRoot.new do
            title "Server Settings"
            background '#ddd'
            padx 15
            pady 15
            minsize(500, 800)
            maxsize(500,1080)
        end

        #canvas to we can scroll
        @canvas = TkCanvas.new(@root) do
            pack(side: 'left', fill: 'y', expand: 1)
        end

        #container for all the widgets and the page
        @parent_frame = TkFrame.new(@canvas) do
            width 470
            height 1400
            pack(side: 'left', fill: 'y', expand: 1)
        end
        # @parent_frame.pack_propagate(0)

        

        #scrollbar to scroll the container
        @scrollbar = TkScrollbar.new(@root) do
            orient('vertical')
            pack(side: 'right', fill: 'y', expand: 0)
        end

        #paints the frame onto the canvas
        TkcWindow.new(@canvas, 1, 1, :window=>@parent_frame, :anchor=>'nw')
        
        #sets the size of the scrollable content.
        @canvas.configure(:scrollregion => "0 0 500 1300")

        #makes sure the grid can accomadate the child widgets
        # @canvas.pack_propagate(0)

        #Don't fully understand it, but its hard to find documentation that's
        #comprehandable
        @canvas.yscrollcommand proc {|*args| @scrollbar.set(*args)}

        #shorthand. I think
        @scrollbar.command proc {|*args| @canvas.yview(*args)}

            #give it a wrapper
            @wrapper_frame = TkFrame.new(@parent_frame) do
                background '#fff'
                padx 5
                pady 20
                width 470
                height 1200
                pack(side: 'top', fill: 'both', expand: 1)
                # grid(column: 0, row: 0, sticky: 'nsew')
            end
            # @wrapper_frame.pack_propagate(0)
                #title goes here
                @top_frame = TkFrame.new(@wrapper_frame) do
                    background '#fff'
                    width 200
                    padx 15
                    pady 15
                    grid(row: 0)
                end

                    #title is centered
                    
                    @title_label = TkLabel.new(@top_frame) do
                        foreground '#333'
                        text 'Server Settings'
                        font TkFont.new("size" => 20)
                        pack(side: 'top', fill: 'x', expand: 1)
                    end
                    
                    #hack to get the column to expand
                    @top_frame_width_fix = TkLabel.new(@top_frame) do
                        background '#fff'
                        pack(side: 'top', fill: 'x', padx: 167, expand: 1)
                    end

                #all the options go here
                @options_frame = TkFrame.new(@wrapper_frame) do
                    background '#ccc'
                    padx 15
                    pady 15
                    grid(row: 1)
                end

                #User Settings
                    @user_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 1)
                    end
                    #section label
                    @user_options_label = TkLabel.new(@user_settings_frame) do
                        background '#aaa'
                        text "User Settings"
                        pady 10
                        pack(side: 'top', fill: 'x', expand: 1)
                    end

                    #shows what user is being updated, and gives instructions
                    @username_label = TkLabel.new(@user_settings_frame) do
                        text "Select a user to modify"
                        pack(side: 'top', fill: 'x', expand: 1)
                    end

                    #allows selection of all the users
                    @user_selector_combobox = TkCombobox.new(@user_settings_frame) do
                        state 'readonly'
                        pack(side: 'top', fill: 'x', expand: 1)
                    end
                    @user_selector_combobox.values = @user_manager.GetUsernames().unshift('New User');
                    #binds the combobox to the label updater
                    @user_selector_combobox.bind('<ComboboxSelected>', update_user_selection)

                    @username_frame = TkFrame.new(@user_settings_frame) do
                        pack(side: 'top', fill: 'x', expand: 1)
                    end

                    #allows the username to be edited
                    @username_textentry = TkEntry.new(@username_frame) do
                        validate 'focusout'
                        validatecommand username_validation
                        width 35
                        pack(side: 'left', fill: 'x', expand: 1)
                    end
                    @username_textentry.value = "-Username-"

                    #allows the user settings to be saved
                    @user_save_button = TkButton.new(@username_frame) do
                        width 10
                        text "Save"
                        command user_save_button_clicked
                        pack(side: 'right', fill: 'x', expand: 1)
                    end

                    @password_frame = TkFrame.new(@user_settings_frame) do
                        pack(side: 'top', fill: 'x', expand: 1)
                    end

                    #allows the password to be updated.
                    #NOTE: Password cannot be retrieved from an existing user
                    #Need to add password validation
                    @password_textentry = TkEntry.new(@password_frame) do
                        validate 'focusout'
                        validatecommand password_validation
                        width 35
                        pack(side: 'left', fill: 'x', expand: 1)
                    end
                    @password_textentry.value = "-Password-"

                    #allows the user settings to be deleted
                    @user_delete_button = TkButton.new(@password_frame) do
                        width 10
                        text "Remove"
                        command user_delete_button_clicked
                        pack(side: 'right', fill: 'x', expand: 1)
                    end

                    #Section label
                    @website_style_settings_label = TkLabel.new(@options_frame) do
                        width 41
                        background '#aaa'
                        text "Website Style Settings"
                        pady 10
                        grid(row: 2)
                    end

        #Fill Color Settings

                   #Frame for the Background color settings
                    @background_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 3)
                    end

                        #Allows editing for the Background color
                        @background_color_combobox = TkCombobox.new(@background_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @background_color_combobox.value = "Background Color"
                        @background_color_combobox.values = @default_colors

                        #Save button for Background text color setting
                        @background_color_save_button = TkButton.new(@background_color_settings_frame) do
                            width 10
                            text "Save"
                            command background_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                    #Frame for the Foreground Color settings
                    @foreground_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 4)
                    end

                        #Allows editing for the Foreground color
                        @foreground_color_combobox = TkCombobox.new(@foreground_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @foreground_color_combobox.value = "Foreground Color"
                        @foreground_color_combobox.values = @default_colors

                        #Save button for Foreground color setting
                        @foreground_color_save_button = TkButton.new(@foreground_color_settings_frame) do
                            width 10
                            text "Save"
                            command foreground_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                    #Frame for the Header background color settings
                    @header_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 5)
                    end

                        #Allows editing for the Header color
                        @header_color_combobox = TkCombobox.new(@header_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @header_color_combobox.value = "Header Color"
                        @header_color_combobox.values = @default_colors

                        #Save button for Header Color setting
                        @header_color_save_button = TkButton.new(@header_color_settings_frame) do
                            width 10
                            text "Save"
                            command header_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                    #Frame for the Navigation Bar color settings
                    @navbar_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 6)
                    end

                        #Allows editing for the Navigation Bar color
                        @navbar_color_combobox = TkCombobox.new(@navbar_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @navbar_color_combobox.value = "Navigation Bar Color"
                        @navbar_color_combobox.values = @default_colors

                        #Save button for Navigation Bar text setting
                        @navbar_color_save_button = TkButton.new(@navbar_color_settings_frame) do
                            width 10
                            text "Save"
                            command navbar_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end
                    

        #Text Settings


            #Header

                        #Frame for the Header Text color settings
                    @header_text_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 7)
                    end

                        #Allows editing for the Header text color
                        @header_text_color_combobox = TkCombobox.new(@header_text_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @header_text_color_combobox.value = "Header Text Color"
                        @header_text_color_combobox.values = @default_colors

                        #Save button for Header text color setting
                        @header_text_color_save_button = TkButton.new(@header_text_color_settings_frame) do
                            width 10
                            text "Save"
                            command header_text_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Header Text Font settings
                    @header_text_font_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 8)
                    end

                        #Allows editing for the Header Text Font
                        @header_text_font_combobox = TkCombobox.new(@header_text_font_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @header_text_font_combobox.value="Header Text Font"
                        @header_text_font_combobox.values = @default_fonts

                        #Save button for Header Text Font setting
                        @header_text_font_save_button = TkButton.new(@header_text_font_settings_frame) do
                            width 10
                            text "Save"
                            command header_text_font_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Header Text Size settings
                    @header_text_size_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 9)
                    end

                        #Allows editing for the Header Text Size
                        @header_text_size_combobox = TkCombobox.new(@header_text_size_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @header_text_size_combobox.value = "Header Text Size"
                        @header_text_size_combobox.values = @defualt_text_sizes

                        #Save button for Header Text Size setting
                        @header_text_size_save_button = TkButton.new(@header_text_size_settings_frame) do
                            width 10
                            text "Save"
                            command header_text_size_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

            #Navigation

                        #Frame for the Navigation Bar Text Color settings
                    @navbar_text_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 10)
                    end

                        #Allows editing for the Navigation Bar Text Color
                        @navbar_text_color_combobox = TkCombobox.new(@navbar_text_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @navbar_text_color_combobox.value = "Navigation Bar Text Color"
                        @navbar_text_color_combobox.values = @default_colors

                        #Save button for Navigation Bar Text Color setting
                        @navbar_text_color_save_button = TkButton.new(@navbar_text_color_settings_frame) do
                            width 10
                            text "Save"
                            command navbar_text_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Navigation Bar Text Font settings
                    @navbar_text_font_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 11)
                    end

                        #Allows editing for the Navigation Bar Text Font
                        @navbar_text_font_combobox = TkCombobox.new(@navbar_text_font_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @navbar_text_font_combobox.value="Navigation Bar Text Font"
                        @navbar_text_font_combobox.values = @default_fonts

                        #Save button for Navigation Bar Text Font setting
                        @navbar_text_font_save_button = TkButton.new(@navbar_text_font_settings_frame) do
                            width 10
                            text "Save"
                            command navbar_text_font_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Navigation Bar Text Size settings
                    @navbar_text_size_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 12)
                    end

                        #Allows editing for the Navigation Bar Text Size
                        @navbar_text_size_combobox = TkCombobox.new(@navbar_text_size_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @navbar_text_size_combobox.value = "Navigation Bar Text Size"
                        @navbar_text_size_combobox.values = @defualt_text_sizes

                        #Save button for Navigation Bar Text Size setting
                        @navbar_text_size_save_button = TkButton.new(@navbar_text_size_settings_frame) do
                            width 10
                            text "Save"
                            command navbar_text_size_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

            #Body

                        #Frame for the Body Text Color settings
                    @body_text_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 13)
                    end

                        #Allows editing for the Body Text Color
                        @body_text_color_combobox = TkCombobox.new(@body_text_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @body_text_color_combobox.value = "Body Text Color"
                        @body_text_color_combobox.values = @default_colors

                        #Save button for Body Text Color setting
                        @body_text_color_save_button = TkButton.new(@body_text_color_settings_frame) do
                            width 10
                            text "Save"
                            command body_text_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Body Text Font settings
                    @body_text_font_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 14)
                    end

                        #Allows editing for the Body Text Font
                        @body_text_font_combobox = TkCombobox.new(@body_text_font_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @body_text_font_combobox.value="Body Text Font"
                        @body_text_font_combobox.values = @default_fonts

                        #Save button for Body Text Font setting
                        @body_text_font_save_button = TkButton.new(@body_text_font_settings_frame) do
                            width 10
                            text "Save"
                            command body_text_font_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Body Text Size settings
                    @body_text_size_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 15)
                    end

                        #Allows editing for the Body Text Size
                        @body_text_size_combobox = TkCombobox.new(@body_text_size_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @body_text_size_combobox.value = "Body Text Size"
                        @body_text_size_combobox.values = @defualt_text_sizes

                        #Save button for Body Text Size setting
                        @body_text_size_save_button = TkButton.new(@body_text_size_settings_frame) do
                            width 10
                            text "Save"
                            command body_text_size_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

            #Links

                        #Frame for the Link Text Color settings
                    @link_text_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 16)
                    end

                        #Allows editing for the Link Text Color
                        @link_text_color_combobox = TkCombobox.new(@link_text_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @link_text_color_combobox.value = "Link Text Color"
                        @link_text_color_combobox.values = @default_colors

                        #Save button for Link Text Color setting
                        @link_text_color_save_button = TkButton.new(@link_text_color_settings_frame) do
                            width 10
                            text "Save"
                            command link_text_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Link Text Font settings
                    @link_text_font_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 17)
                    end

                        #Allows editing for the Link Text Font
                        @link_text_font_combobox = TkCombobox.new(@link_text_font_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @link_text_font_combobox.value="Link Text Font"
                        @link_text_font_combobox.values = @default_fonts

                        #Save button for Link Text Font setting
                        @link_text_font_save_button = TkButton.new(@link_text_font_settings_frame) do
                            width 10
                            text "Save"
                            command link_text_font_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Link Text Size settings
                    @link_text_size_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 18)
                    end

                        #Allows editing for the Link Text Size
                        @link_text_size_combobox = TkCombobox.new(@link_text_size_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @link_text_size_combobox.value = "Link Text Size"
                        @link_text_size_combobox.values = @defualt_text_sizes

                        #Save button for Link Text Size setting
                        @link_text_size_save_button = TkButton.new(@link_text_size_settings_frame) do
                            width 10
                            text "Save"
                            command link_text_size_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

            #Used Links

                        #Frame for the Used Link Text Color settings
                    @usedlink_text_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 19)
                    end

                        #Allows editing for the Used Link Text Color
                        @usedlink_text_color_combobox = TkCombobox.new(@usedlink_text_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color 
                        @usedlink_text_color_combobox.value = "Used Link Text Color"
                        @usedlink_text_color_combobox.values = @default_colors

                        #Save button for Used Link Text Color setting
                        @usedlink_text_color_save_button = TkButton.new(@usedlink_text_color_settings_frame) do
                            width 10
                            text "Save"
                            command usedlink_text_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Used Link Text Font settings
                    @usedlink_text_font_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 20)
                    end

                        #Allows editing for the Used Link Text Font
                        @usedlink_text_font_combobox = TkCombobox.new(@usedlink_text_font_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @usedlink_text_font_combobox.value="Used Link Text Font"
                        @usedlink_text_font_combobox.values = @default_fonts

                        #Save button for Used Link Text Font setting
                        @usedlink_text_font_save_button = TkButton.new(@usedlink_text_font_settings_frame) do
                            width 10
                            text "Save"
                            command usedlink_text_font_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Used Link Text Size settings
                    @usedlink_text_size_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 21)
                    end

                        #Allows editing for the Used Link Text Size
                        @usedlink_text_size_combobox = TkCombobox.new(@usedlink_text_size_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @usedlink_text_size_combobox.value = "Used Link Text Size"
                        @usedlink_text_size_combobox.values = @defualt_text_sizes

                        #Save button for Used Link Text Size setting
                        @usedlink_text_size_save_button = TkButton.new(@usedlink_text_size_settings_frame) do
                            width 10
                            text "Save"
                            command usedlink_text_size_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

            #Footer

                        #Frame for the Footer Text Color settings
                    @footer_text_color_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 22)
                    end

                        #Allows editing for the Footer Text Color
                        @footer_text_color_combobox = TkCombobox.new(@footer_text_color_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @footer_text_color_combobox.value = "Footer Text Color"
                        @footer_text_color_combobox.values = @default_colors

                        #Save button for Footer Text Color setting
                        @footer_text_color_save_button = TkButton.new(@footer_text_color_settings_frame) do
                            width 10
                            text "Save"
                            command footer_text_color_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                        #Frame for the Footer Text Font settings
                    @footer_text_font_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 23)
                    end

                        #Allows editing for the Footer Text Font
                        @footer_text_font_combobox = TkCombobox.new(@footer_text_font_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @footer_text_font_combobox.value="Footer Text Font"
                        @footer_text_font_combobox.values = @default_fonts

                        #Save button for Footer Text Font setting
                        @footer_text_font_save_button = TkButton.new(@footer_text_font_settings_frame) do
                            width 10
                            text "Save"
                            command footer_text_font_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end
                        
                        #Frame for the Footer Text Size settings
                    @footer_text_size_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 24)
                    end

                        #Allows editing for the Footer Text Size
                        @footer_text_size_combobox = TkCombobox.new(@footer_text_size_settings_frame) do
                            width 32
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        #default color options
                        @footer_text_size_combobox.value = "Footer Text Size"
                        @footer_text_size_combobox.values = @defualt_text_sizes

                        #Save button for Footer Text Size setting
                        @footer_text_size_save_button = TkButton.new(@footer_text_size_settings_frame) do
                            width 10
                            text "Save"
                            command footer_text_size_save_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

            #CSS

                        #Frame for the CSS settings
                    @css_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 25)
                    end

                        @css_text_settings_cell = TkFrame.new(@css_settings_frame) do
                            grid(column: 0, row: 0)
                        end

                        @css_text_box = TkText.new(@css_text_settings_cell) do
                            width 24
                            height 20
                            wrap 'word'
                            pack(side: 'left', fill: 'both', expand: 1)
                        end

                        @css_text_box_scrollbar = TkScrollbar.new(@css_text_settings_cell) do
                            orient('vertical')
                            pack(side: 'right', fill: 'y', expand: 1)
                        end

                        @css_text_box.yscrollcommand proc {|*args| @css_text_box_scrollbar.set(*args)}
                        @css_text_box_scrollbar.command proc {|*args| @css_text_box.yview(*args)}

                        @css_button_settings_cell = TkFrame.new(@css_settings_frame) do
                            grid(column: 1, row: 0)
                        end

                        @css_load_button = TkButton.new(@css_button_settings_cell) do
                            width 10
                            height 10
                            text "Load CSS"
                            command css_load_button_clicked
                            pack(side: 'top', fill: 'x', expand: 1)
                        end

                        @css_save_button = TkButton.new(@css_button_settings_cell) do
                            width 10
                            height 10
                            text "Save CSS"
                            command css_save_button_clicked
                            pack(side: 'bottom', fill: 'x', expand: 1)
                        end

                    @backup_settings_frame = TkFrame.new(@options_frame) do
                        grid(row: 26)
                    end

                        @backup_location_text = TkEntry.new(@backup_settings_frame) do
                            width 35
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        @backup_location_text.value="Backup Location"

                        @backup_location_save_button = TkButton.new(@backup_settings_frame) do
                            width 10
                            text "Save"
                            command backup_location_save_button_cliked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

                @server_settings_frame = TkFrame.new(@wrapper_frame) do
                    grid(row: 2)
                end
                    @backup_frame = TkFrame.new(@server_settings_frame) do
                        grid(row: 0)
                    end
                        @backup_server_button = TkButton.new(@backup_frame) do
                            width 15
                            text "Backup"
                            command backup_server_button_clicked
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        @load_server_backup_button = TkButton.new(@backup_frame) do
                            width 15
                            text "Load Backup"
                            command load_server_backup_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end
                    @start_stop_server_frame = TkFrame.new(@server_settings_frame) do
                        grid(row: 1)
                    end
                        @start_server_button = TkButton.new(@start_stop_server_frame) do
                            width 15
                            text "Start Server"
                            command start_server_button_clicked
                            pack(side: 'left', fill: 'x', expand: 1)
                        end
                        @stop_server_button = TkButton.new(@start_stop_server_frame) do
                            width 15
                            text "Stop Server"
                            command stop_server_button_clicked
                            pack(side: 'right', fill: 'x', expand: 1)
                        end

        end
end
controller = Controller.new
Tk.mainloop
