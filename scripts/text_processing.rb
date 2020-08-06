def save_story(name, story)
    File.open("resources/public/stories/#{name}.txt", 'w') { |f| f.puts story}
end

def load_story(name)
    # puts Dir.pwd
    story = File.read("resources/public/stories/#{name}.txt")
    story
end

def get_story_names
    story_names = []
    filenames = Dir.entries("resources/public/stories")
    filenames = filenames.drop(2)
    i = 0
    while i < filenames.length()
        filenames[i] = filenames[i].split('.')[0]
        i += 1
    end
    puts filenames
    filenames
end