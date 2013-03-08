def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def info(text); colorize(text, 32); end
def notice(text); colorize(text, 32); end
