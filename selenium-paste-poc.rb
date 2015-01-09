require 'selenium-webdriver'
require 'rspec-expectations'
require 'headless'

def setup
  @headless = Headless.new
  @headless.start
  @driver = Selenium::WebDriver.for :firefox
end

def teardown
  @driver.quit
  @headless.destroy
end

def run
  setup
  yield
  teardown
end

def first_div_in_selection
  
end

run do
  @driver.get "http://127.0.0.1:9001/p/pastetest3"
  begin
    #iframes are filled via js later, so wait a litte bit
    while (iframe = @driver.find_element(:tag_name => 'iframe')).size == 0
    end
    puts "found"
  rescue
    puts "not found"
    retry
  end
  #first iframe outer_ace and inside inner_ace, we need the latter
  @driver.switch_to.frame(iframe)
  iframe = @driver.find_element(:tag_name => 'iframe')
  @driver.switch_to.frame(iframe)


#  puts @driver.execute_script("return window.getSelection().getRangeAt(0).startContainer.parentNode.parentNode.textContent")
#  @driver.find_element(:id=>'magicdomid2').send_keys(:control,'a')
#  @driver.find_element(:id=>'magicdomid2').send_keys(:return) #clears everything
#  @driver.find_element(:id=>'magicdomid2').send_keys('foobar')
  @driver.find_element(:id=>'magicdomid2').send_keys(:control,'a')
  @driver.find_element(:id=>'magicdomid2').send_keys(:control,'c')
  @driver.find_element(:id=>'magicdomid2').send_keys(:control,'v')
  @driver.find_element(:id=>'magicdomid2').send_keys(:control,'v')
#  puts @driver.execute_script("return window.getSelection().getRangeAt(0).startContainer.parentNode.parentNode.textContent")
end
