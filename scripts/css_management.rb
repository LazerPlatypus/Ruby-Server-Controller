class CssCreator

    def initialize
        @css_text = ""
        @css_options = ""
        @css_attributes = [[]]
        if File.exist?("resources/css_options.txt")
            @css_options = IO.read("resources/css_options.txt")
        else
            @css_options = IO.read("resources/default_css_options.txt")
        end
        GetOptions()
    end

    def GetOptions()
        css_sections = @css_options.split("\n")
        i = 0
        while i < css_sections.length()
            if i == 0
                @css_attributes = [css_sections[i].split("|")]
            else
                @css_attributes.push(css_sections[i].split("|"))
            end
            i += 1
        end
        @css_attributes
    end

    def ChangeOption(option)
        @css_attributes[option[0]][option[1]] = option[2]
        BuildCss()
    end

    def GetCss()
        if File.exist?("resources/public/style.css")
            @css_text = IO.read("resources/public/style.css")
        end
        @css_text
    end

    def SaveCssEdit(css_text)
        @css_text = css_text
        IO.write("resources/public/style.css", "#{@css_text}")
    end

    def MakeSection(attribute)
        i = 0
        unless attribute[i] == "a:link" || attribute[i] == "a:visited"
            while i < attribute.length
                if i == 0
                    @css_text.concat("##{attribute[i]} {\n")
                else
                    @css_text.concat("#{attribute[i]};\n")
                end
                i += 1
            end
        else
            while i < attribute.length
                if i == 0
                    @css_text.concat("#{attribute[i]} {\n")
                else
                    @css_text.concat("#{attribute[i]};\n")
                end
                i += 1
            end
        end
        @css_text.concat("}\n")
    end

    def BuildCss()
        @css_text = ""
        @css_attributes.each do |attribute|
            MakeSection(attribute)
        end
        if File.exist?("resources/css_helper.txt")
            @css_text.insert(0,IO.read("resources/css_helper.txt"))
        end
        IO.write("resources/public/style.css","#{@css_text}")
        SaveCss()
    end

    def SaveCss()
        IO.write("resources/css_options.txt", "#{@css_options}")
    end

end
