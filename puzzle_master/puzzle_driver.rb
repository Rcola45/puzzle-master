require 'selenium-webdriver'

class PuzzleDriver
  attr_reader :browser, :driver
  def initialize(browser = :chrome)
    @browser = browser
    @driver = init_webdriver
  end

  def get(url)
    return unless @driver

    @driver.get(url)
  end

  def find_elements_from_css(css)
    find_elements(:css, css)
  end

  def find_elements(search_type, search_value)
    return unless @driver

    wait = init_wait
    elements = []
    wait.until do
      elements = @driver.find_elements(search_type, search_value)
      elements.any?
    end
    elements
  end

  def quit
    @driver.quit
    @driver = nil
  end

  private

  def init_wait(timeout = 5)
    Selenium::WebDriver::Wait.new(timeout: timeout)
  end

  def init_webdriver
    Selenium::WebDriver.for(@browser)
  end
end
