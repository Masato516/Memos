require "bundler/setup"
# 一括require
Bundler.require

# Gemを用いてPDFを取り込む
reader = PDF::Reader.new("BradSchoenfold.pdf")

start_time = Time.now

pdf_text = ""

reader.pages.each do |page|
  pdf_text.concat(page.text)
end

File.open("output.txt", mode = "w"){|f|
  f.write(pdf_text)
}

p pdf_text

p "処理概要 #{Time.now - start_time}s"
