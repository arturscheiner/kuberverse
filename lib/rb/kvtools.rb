# kuberverse kubernetes cluster lab
# version: 0.5.0
# description: this Vagrantfile creates a cluster with masters and workers
# created by Artur Scheiner - artur.scheiner@gmail.com

class KvTools
    def defineIp(type,i,kvln)
        case type
        when "master" 
          return kvln.split('.')[0..-2].join('.') + ".#{i + 10}"
        when "worker"
          return kvln.split('.')[0..-2].join('.') + ".#{i + 20}"
        when "scaler"
          return kvln.split('.')[0..-2].join('.') + ".#{i + 50}"
        end
    end

    def addToHosts(ip,hostname)
        hosts=".kv/hosts"
        Dir.mkdir('.kv') unless File.exists?('.kv')
        File.new(hosts, "w") unless File.exists?(hosts)

        line_exist=File.readlines(hosts).grep(/#{ip}/).size

        if line_exist > 0
            puts "this  #{ip} and #{hostname} is already in .kv/hosts file"
        else
            puts "updatind .kv/hosts file with #{ip} and #{hostname}"
            File.open(hosts, "a") do |line|
                line.puts "#{ip} #{hostname} #{hostname}.lab.local #{hostname}.local"
            end
        end
    end
    
    def cleanKvDir()
        kv_dir=".kv"
        FileUtils.remove_dir(kv_dir) if File.directory?(kv_dir)
    end

    def iPSa(type,count)
      iPS = Array[]
      (0..count-1).each do |node|
        iPS.push(self.defineIp(type,node,KV_LAB_NETWORK))
      end
      return iPS   
    end

    def colorize(text, color_code)
        "\e[#{color_code}m#{text}\e[0m"
       end
      
      def red(text); colorize(text, 31); end
      def green(text); colorize(text, 32); end
      def yellow(text); colorize(text, 33); end
      def blue(text); colorize(text, 34); end
      
end

class String
    def black; "\e[30m#{self}\e[0m" end
    def red; "\e[31m#{self}\e[0m" end
    def green; "\e[32m#{self}\e[0m" end
    def brown; "\e[33m#{self}\e[0m" end
    def blue; "\e[34m#{self}\e[0m" end
    def magenta; "\e[35m#{self}\e[0m" end
    def cyan; "\e[36m#{self}\e[0m" end
    def gray; "\e[37m#{self}\e[0m" end
    def yellow; "\e[33m#{self}\e[0m" end
   
    def bg_black; "\e[40m#{self}\e[0m" end
    def bg_red; "\e[41m#{self}\e[0m" end
    def bg_green; "\e[42m#{self}\e[0m" end
    def bg_brown; "\e[43m#{self}\e[0m" end
    def bg_blue; "\e[44m#{self}\e[0m" end
    def bg_magenta; "\e[45m#{self}\e[0m" end
    def bg_cyan; "\e[46m#{self}\e[0m" end
    def bg_gray; "\e[47m#{self}\e[0m" end
   
    def bold; "\e[1m#{self}\e[22m" end
    def italic; "\e[3m#{self}\e[23m" end
    def underline; "\e[4m#{self}\e[24m" end
    def blink; "\e[5m#{self}\e[25m" end
    def reverse_color; "\e[7m#{self}\e[27m" end
  end