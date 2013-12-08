#!/usr/bin/env ruby

#try all combinations

opentags = ['<strong>', '<em>', '<u>', '<s>'];
p0=opentags.permutation(0).to_a
p1=opentags.permutation(1).to_a
p2=opentags.permutation(2).to_a
p3=opentags.permutation(3).to_a
p4=opentags.permutation(4).to_a
pall=p0+p1+p2+p3+p4
pall=pall.flatten(0)

def closeit(str)
  str.split('<').reverse.map{|e|if e=="" then e else "</"+e end}.join
end

testchunk=[]
testchunk_nr=0
pall.to_a.each do |perm|
  pall.to_a.each do |perm2|
    pall.to_a.each do |perm3|
      testchunk.push "#{perm.join}a#{closeit(perm.join)}#{perm2.join}b#{closeit(perm2.join)}#{perm3.join}c#{closeit(perm3.join)}<br>"
      if testchunk.size >250
        #this file will be send to pad/import
        File.open("testchunk_nr#{testchunk_nr}.html","w") do |f|
          f.write("<!doctype html>\n<html lang=\"en\">\n<head>\n<title>test3322370</title>\n<meta charset=\"utf-8\">\n<style> * { font-family: arial, sans-serif;\nfont-size: 13px;\nline-height: 17px; }ul.indent { list-style-type: none; }ol { list-style-type: decimal; }ol ol { list-style-type: lower-latin; }ol ol ol { list-style-type: lower-roman; }ol ol ol ol { list-style-type: decimal; }ol ol ol ol ol { list-style-type: lower-latin; }ol ol ol ol ol ol{ list-style-type: lower-roman; }ol ol ol ol ol ol ol { list-style-type: decimal; }ol  ol ol ol ol ol ol ol{ list-style-type: lower-latin; }</style>\n</head>\n<body>")
          f.write testchunk.join("\n")
          f.write("\n</body>\n</html>")
        end

        #this file will be compared to the export, because ep enforces some ordering on elements
        #->strong->em->u->s so replace them, in the worst case for 4 attributes it takes 3 iterations to move <strong> to the outside
#        testchunk.map! do |line|
#          3.times do 
#          line.gsub!('<em><strong>','<strong><em>')
#          line.gsub!('</strong></em>','</em></strong>')
#          line.gsub!('<u><strong>','<strong><u>')
#          line.gsub!('</strong></u>','</u></strong>')
#          line.gsub!('<s><strong>','<strong><s>')
#          line.gsub!('</strong></s>','</s></strong>')
#          line.gsub!('<u><em>','<em><u>')
#          line.gsub!('</em></u>','</u></em>')
#          line.gsub!('<s><em>','<em><s>')
#          line.gsub!('</em></s>','</s></em>')
#          line.gsub!('<s><u>','<u><s>')
#          line.gsub!('</u></s>','</s></u>')
#          end
#          line
#        end
#        File.open("testchunk_nr#{testchunk_nr}.html_fordiff","w") do |f|
#          f.write("<!doctype html>\n<html lang=\"en\">\n<head>\n<title>test3322370</title>\n<meta charset=\"utf-8\">\n<style> * { font-family: arial, sans-serif;\nfont-size: 13px;\nline-height: 17px; }ul.indent { list-style-type: none; }ol { list-style-type: decimal; }ol ol { list-style-type: lower-latin; }ol ol ol { list-style-type: lower-roman; }ol ol ol ol { list-style-type: decimal; }ol ol ol ol ol { list-style-type: lower-latin; }ol ol ol ol ol ol{ list-style-type: lower-roman; }ol ol ol ol ol ol ol { list-style-type: decimal; }ol  ol ol ol ol ol ol ol{ list-style-type: lower-latin; }</style>\n</head>\n<body>")
#          f.write testchunk.join("\n")
#          f.write("\n</body>\n</html>")
#        end
        testchunk=[]
        testchunk_nr+=1
      end
    end
  end
end
