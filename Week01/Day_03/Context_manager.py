from playwright.sync_api import sync_playwright

class browser_class:
    def __enter__(self):
        print("entering browser_class")
        self.playwright = sync_playwright().start()
        self.browser = self.playwright.chromium.launch(headless=True)
        self.page = self.browser.new_page()

        return self.page

    def __exit__(self, exc_type, exc_val, exc_tb):
        print("closing browser_class")
        self.browser.close()
        self.playwright.stop()

        if exc_type:
            print(f"exception: {exc_type}")

        return False


with browser_class() as browser:
    print("Before loading browser_class")
    browser.goto("http://google.com")
    print(browser.title())
