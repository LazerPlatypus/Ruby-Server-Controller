require 'digest'
class UserManagement

    def initialize
        @username_password_pairs = [[]]
        @pairs_delimiter = Digest::SHA512.base64digest("Red Rock Frog Fence") #in the future, this will be configurable
        @individual_delimiter = Digest::SHA512.base64digest("Doctor Chair Bomb Panther") #in the future, this will be configurable
        # @pairs_delimiter = "||||||||"
        # @individual_delimiter = "////////"
    end

    def GetUsernames()
        GetUsers()
        usernames = []
        @username_password_pairs.each do |up|
            usernames.push(up[0])
        end
        usernames
    end

    def MakeUser(username, password)
        username.strip!
        password.strip!
        unless (username == "" && password == "")
            GetUsers()
            if (@username_password_pairs == [[]])
                @username_password_pairs = [[username.to_s, HashPassword(password).to_s]]
                SavePasswords()
                return true
            else
                makeuser = true
                @username_password_pairs.each do |up|
                if username.to_s == up[0].to_s
                    makeuser = false
                    break
                end
                end
                if makeuser
                    @username_password_pairs.push([username.to_s, HashPassword(password).to_s])
                    SavePasswords()
                end
            end
            return makeuser
        else
            return false
        end
    end

    def ModifyUser(username, new_username, new_password)
        username.strip!
        new_username.strip!
        RemoveUser(username)
        MakeUser(new_username, new_password)
    end

    def RemoveUser(username)
        username.strip!
        GetUsers()
        @username_password_pairs.each do |up|
            if username.to_s == up[0].to_s
                @username_password_pairs.delete(up)
                SavePasswords()
                return true
            end
        end
        false
    end
    
    #might be overkill, or completely insecure,
    #But I cant think of a better way to safely
    #delimit the usernames from the passwords.
    #after all, It would cause serious issues if a username
    #contained the delimiter.
    #using base64digest for the delimiter so if a user has the same
    #password it wont escape the delimiter (base64 contains
    #characters not present in hexdigest).
    #NOTE: user passwords use hexdigest
    def GetUsers()
        if File.exist?("usernames_passwords.rpwf")
            username_password_file = IO.read("usernames_passwords.rpwf")
            username_passwords = username_password_file.split("#{@pairs_delimiter}")
            username_password_pairs = [[]]
            i = 0
            while i < username_passwords.length()
                if i == 0
                    username_password_pairs = [username_passwords[i].split("#{@individual_delimiter}")]
                else
                    username_password_pairs.push(username_passwords[i].split("#{@individual_delimiter}"))
                end
                i += 1
            end
            @username_password_pairs = username_password_pairs
        else
            username_password_file = File.new("usernames_passwords.rpwf", "w")
            username_password_file.close()
        end
    end
    
    #takes a plaintext password and hashes it
    #down the road it would be cool to
    #salt them, and use a different tool
    #to run iterations on them, but dont have time
    #or resources to do that now
    def HashPassword(password)
        password.strip!
        hashed_password = Digest::SHA512.hexdigest(password)
        hashed_password
    end
    
    #takes a plaintext password attempt, hashes it,
    #and compares it to a stored password
    def CheckPassword(password, hashed_password)
        if HashPassword(password) == hashed_password
            #puts "good password"
            return true
        end
        false
    end


    def login(username, password)
        username.strip!
        password.strip!
        GetUsers()
        @username_password_pairs.each do |up|
            if username.to_s == up[0].to_s
                if CheckPassword(password, up[1])
                    puts "success"
                    return true
                end
                break
            end
        end
        puts "failure"
        false
    end

    def SavePasswords()
        username_passwords = []
        @username_password_pairs.each do |up|
            username_passwords.push(up.join("#{@individual_delimiter}"))
        end
        username_password_file = username_passwords.join("#{@pairs_delimiter}")
        IO.write("usernames_passwords.rpwf", "#{username_password_file.to_s}")
    end

end





