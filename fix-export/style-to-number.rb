#!/usr/bin/env ruby
# reads a string attribs+a+(close attribs)attribs+b(close attribs)attribs+c(close attribs)
# and outputs a numerical value representing the style at each character
#
# there are different multiple ways to represent the style of a string ie
# <strong><em>a</em></strong> == <em><strong>a</strong></em>
# so we need a way to test if they are the same

ATTRIB_MAP = {
  "<strong>"=>8,
  "<em>"=>4,
  "<u>"=>2,
  "<s>"=>1,
  "</strong>"=>-8,
  "</em>"=>-4,
  "</u>"=>-2,
  "</s>"=>-1
}

#look for >, get the value of the tag before > and return an array
#that says how much to increase the value+the new remaining string
def get_value_from_tag(str)
  index = str.index(">")
  return [0,""] if index == nil
  tag_value = ATTRIB_MAP[ str[0..index] ]
  return [ tag_value,str[index+1..-1] ]
end

STDIN.readlines.each{|line|
  split=line.split(/[abc]/)
  split.pop #we dont need whats after c

  val=0
  result=[]
  split.each do |attribs|
    rest=attribs
    while(rest != "") do
      value,rest = get_value_from_tag(rest)
      val += value
    end
    result.push val 
  end
  puts "a:#{result[0]},b:#{result[1]},c:#{result[2]}"
}
