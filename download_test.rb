# coding: UTF-8

require 'selenium-webdriver'

# ファイルを格納するdirectory
DOWNLOAD_DIR = Dir.pwd

# webdriverの条件
# ファイルをダウンロードする場合、驚くほどオプションが多いです
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-gpu')
options.add_argument('--disable-popup-blocking')
options.add_argument('--window-size=1200,2000') # ここで大きさ決められたんだ
options.add_preference(:download, directory_upgrade: true, prompt_for_download: false, default_directory: DOWNLOAD_DIR)
options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })
driver = Selenium::WebDriver.for :chrome, options: options
# つーか、このへんとか何よ
bridge = driver.send(:bridge)
path = '/session/:session_id/chromium/send_command'
path[':session_id'] = bridge.session_id
bridge.http.call(:post, path, cmd: 'Page.setDownloadBehavior', params: {behavior: 'allow', downloadPath: DOWNLOAD_DIR})
# これは普通
wait = Selenium::WebDriver::Wait.new(:timeout => 30)

# スクショの大きさです
#page_width = 1200
#page_height = 2000
#driver.manage.window.resize_to(page_width, page_height)

# ログイン先のURL
START_URL = 'http://www.soumu.go.jp/johotsusintokei/field/tsuushin03.html'
driver.navigate.to START_URL
# ちょっと確認のためです
driver.save_screenshot './dashboard.png'
# 割と意味のないwait
sleep 5

#driver.find_element(:id, 'loginFormButton').click
driver.find_element(:xpath, '//*[@id="main_content_area"]/table/tbody/tr[6]/td/span/div/a[2]').click

# ダウンロードが終わるまで待たないといけないのが微妙
sleep 20
driver.save_screenshot './download.png'
