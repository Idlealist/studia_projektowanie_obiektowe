import time
import pytest
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

BASE_URL = "https://www.olx.pl/"

@pytest.fixture(scope="module")
def driver():
    chrome_options = Options()
    #chrome_options.add_argument("--headless")
    chrome_options.add_argument("--no-sandbox")
    browser = webdriver.Chrome(options=chrome_options)
    browser.maximize_window()
    browser.implicitly_wait(10)
    browser.get(BASE_URL)
    yield browser
    browser.quit()

def test_page_title(driver):
    assert "OLX" in driver.title
    assert "ogłoszenia" in driver.title.lower()
    assert driver.current_url.startswith("https://")
    assert len(driver.title) > 10

def test_cookie_banner_accept(driver):
    driver.get(BASE_URL)
    accept_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.ID, "onetrust-accept-btn-handler"))
    )
    assert accept_button.is_displayed(), "Cookie accept button not visible"
    assert "Akceptuję" in accept_button.text
    accept_button.click()
    WebDriverWait(driver, 5).until(
        EC.invisibility_of_element_located((By.ID, "onetrust-banner-sdk"))
    )
    cookie_banners = driver.find_elements(By.ID, "onetrust-banner-sdk")
    assert not cookie_banners or not cookie_banners[0].is_displayed(), "Cookie banner still visible"

def test_search_field_exists(driver):
    search_input = driver.find_element(By.ID, "search")
    assert search_input is not None
    assert search_input.get_attribute("placeholder") != ""
    assert search_input.is_displayed()

def test_header_elements(driver):
    wait = WebDriverWait(driver, 10)
    assert wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '[data-testid="olx-logo-link"]')))
    assert wait.until(EC.presence_of_element_located((By.XPATH, '//a[contains(., "Czat")]')))
    assert wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '[data-testid="observed-page-link"]')))
    assert wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '[data-testid="notification-hub"]')))
    assert wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '[data-cy="myolx-link"]')))
    assert wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, '[data-cy="post-new-ad-button"]')))

def test_categories_visible(driver):
    categories = driver.find_elements(By.CSS_SELECTOR, "a[data-testid^='cat']")
    assert len(categories) > 5
    for category in categories[:3]:
        assert category.is_displayed()
        assert category.get_attribute("href").startswith(BASE_URL)
        assert category.text.strip() != ""

def test_search_button_works(driver):
    search_input = driver.find_element(By.ID, "search")
    search_input.clear()
    search_input.send_keys("rower")
    search_button = driver.find_element(By.CSS_SELECTOR, "button[data-testid='search-submit']")
    assert search_button.is_displayed()
    search_button.click()
    WebDriverWait(driver, 10).until(EC.url_contains("q-rower"))
    assert "rower" in driver.current_url

def test_results_list(driver):
    results = driver.find_elements(By.CSS_SELECTOR, '[data-cy$="-card"]')
    assert len(results) > 0
    assert any("rower" in result.text.lower() for result in results[:5])
    for result in results[:3]:
        assert result.is_displayed()

def test_price_from_filter(driver):
    price_from_input = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.CSS_SELECTOR, "input[data-testid='range-from-input']"))
    )
    price_from_input.clear()
    price_from_input.send_keys("500")
    driver.find_element(By.CSS_SELECTOR, "body").click()
    WebDriverWait(driver, 10).until(EC.url_contains("filter_float_price:from"))
    assert "filter_float_price:from%5D=500" in driver.current_url

def test_clear_filters_button(driver):
    clear_button = WebDriverWait(driver, 10).until(
        EC.element_to_be_clickable((By.CSS_SELECTOR, "button[data-testid='filter-clear-all']"))
    )
    assert clear_button.is_displayed()
    assert clear_button.is_enabled()
    clear_button.click()
    time.sleep(4)
    WebDriverWait(driver, 5).until(EC.url_contains("q-rower"))
    assert "filter_" not in driver.current_url

def test_login_link(driver):
    login_link = driver.find_element(By.CSS_SELECTOR, '[data-cy="myolx-link"]')
    assert login_link.is_displayed()
    assert "konto" in login_link.text.lower()
    assert login_link.get_attribute("href").startswith("http")

def test_login_form_exists(driver):
    driver.get(BASE_URL + "konto/")
    email_input = driver.find_element(By.NAME, "username")
    password_input = driver.find_element(By.NAME, "password")
    assert email_input.is_displayed()
    assert password_input.is_displayed()
    assert email_input.get_attribute("type") == "email"
    assert password_input.get_attribute("type") == "password"

def test_footer_navigation(driver):
    driver.get(BASE_URL)
    footer_links = driver.find_elements(By.CSS_SELECTOR, "#footerContent a")
    assert len(footer_links) > 10
    for link in footer_links[:5]:
        href = link.get_attribute("href")
        assert href and href.startswith("http")
        assert link.is_displayed()

def test_logo_navigates_home(driver):
    logo = driver.find_element(By.CSS_SELECTOR, '[data-testid="olx-logo-link"]')
    logo.click()
    WebDriverWait(driver, 10).until(EC.url_to_be(BASE_URL))
    assert driver.current_url == BASE_URL
    assert "ogłoszenia" in driver.title.lower()

def test_category_menu_click(driver):
    driver.get(BASE_URL)
    category = driver.find_element(By.CSS_SELECTOR, "a[data-path='motoryzacja']")
    category.click()
    category_link = driver.find_element(By.CSS_SELECTOR, "a[href='/motoryzacja/'][data-cy^='sub-cat']")
    assert category_link.is_displayed()
    sub_categories = driver.find_elements(By.CSS_SELECTOR, "a[href^='/motoryzacja/']")
    assert len(sub_categories) > 5
    category_link.click()
    WebDriverWait(driver, 10).until(EC.url_contains("motoryzacja"))
    assert "motoryzacja" in driver.current_url

def test_no_search_results(driver):
    search_input = driver.find_element(By.ID, "search")
    search_input.clear()
    search_input.send_keys("asdlkjaslkdjalskdj")
    search_input.submit()
    WebDriverWait(driver, 10).until(EC.url_contains("q-"))
    listing_count = driver.find_element(By.CSS_SELECTOR, '[data-testid="listing-count-msg"]')
    header_message = driver.find_element(By.CSS_SELECTOR, '[data-testid="qa-header-message"]')
    assert "Znaleźliśmy 0 ogłoszeń" in listing_count.text
    assert "Nie znaleźliśmy żadnych wyników" in header_message.text

def test_footer_help_link(driver):
    driver.get(BASE_URL)
    help_link = driver.find_element(By.LINK_TEXT, "Pomoc")
    assert help_link.is_displayed()
    assert help_link.get_attribute("href").startswith("https://")
    assert "pomoc" in help_link.get_attribute("href").lower()

def test_post_ad_button_visible_enabled(driver):
    post_button = driver.find_element(By.CSS_SELECTOR, '[data-cy="post-new-ad-button"]')
    assert post_button.is_displayed()
    assert post_button.is_enabled()
    assert "dodaj" in post_button.text.lower()

def test_ad_cards_image_thumbnails(driver):
    driver.get(BASE_URL + "motoryzacja/")
    cards = driver.find_elements(By.CSS_SELECTOR, '[data-cy$="-card"]')
    for card in cards[:5]:
        img = card.find_element(By.TAG_NAME, "img")
        assert img.is_displayed()
        src = img.get_attribute("src")
        assert src and src.startswith("http")

def test_search_results_count(driver):
    driver.get(BASE_URL)
    search_input = driver.find_element(By.ID, "search")
    search_input.clear()
    search_input.send_keys("laptop")
    search_input.submit()
    count_message = WebDriverWait(driver, 10).until(
        EC.visibility_of_element_located((By.CSS_SELECTOR, '[data-testid="listing-count-msg"]'))
    )
    assert count_message.is_displayed()
    assert any(char.isdigit() for char in count_message.text)

def test_location_input_exists(driver):
    location_input = driver.find_element(By.ID, "location-input")
    assert location_input is not None
    assert location_input.get_attribute("placeholder") == "Cała Polska"
    assert location_input.is_displayed()
    assert location_input.is_enabled()
    location_input.send_keys("Kraków")
    assert location_input.get_attribute("value") == "Kraków"

def test_ads_display(driver):
    driver.get(BASE_URL + "/motoryzacja")
    WebDriverWait(driver, 10).until(
        EC.presence_of_all_elements_located((By.CSS_SELECTOR, '[data-testid="l-card"]'))
    )
    ads = driver.find_elements(By.CSS_SELECTOR, '[data-testid="l-card"]')
    assert len(ads) >= 4
    for ad in ads[:3]:
        assert ad.is_displayed()
        assert ad.find_element(By.TAG_NAME, "img").get_attribute("src") != ""
        assert ad.find_element(By.CSS_SELECTOR, '[data-testid="ad-price"]').text.strip() != ""
        assert ad.find_element(By.CSS_SELECTOR, '[data-cy="ad-card-title"]').text.strip() != ""

def test_favorite_button_in_ads(driver):
    driver.get(BASE_URL + "/motoryzacja")
    ad = driver.find_element(By.CSS_SELECTOR, '[data-testid="l-card"]')
    favorite_button = ad.find_element(By.CSS_SELECTOR, '[data-testid="adAddToFavorites"]')
    assert favorite_button.is_displayed()
    assert favorite_button.is_enabled()
    assert favorite_button.find_element(By.TAG_NAME, "svg").is_displayed()

def test_business_banner_exists(driver):
    driver.get(BASE_URL)
    banner = driver.find_element(By.CSS_SELECTOR, 'a[href*="biznes.olx.pl"]')
    assert banner.text.strip() != ""
    assert banner.get_attribute("href").startswith("http://biznes.olx.pl")
    assert banner.is_enabled()

def test_social_media_links(driver):
    driver.get(BASE_URL)
    social_links = driver.find_elements(By.CSS_SELECTOR, "#footerContent a[href*='facebook.com'], a[href*='instagram.com'], a[href*='youtube.com']")
    assert len(social_links) >= 2
    for link in social_links:
        assert link.is_displayed()
        assert link.get_attribute("href").startswith("https://")
        assert link.get_attribute("target") == "_blank"
        assert link.find_element(By.TAG_NAME, "svg").is_displayed()

def test_search_with_location(driver):
    driver.get(BASE_URL)
    search_input = driver.find_element(By.ID, "search")
    search_input.clear()
    search_input.send_keys("telefon")
    location_input = driver.find_element(By.ID, "location-input")
    location_input.clear()
    location_input.send_keys("Warszawa")
    driver.find_element(By.CSS_SELECTOR, "li[data-testid='suggestion-item']").click()
    driver.find_element(By.CSS_SELECTOR, "button[data-testid='search-submit']").click()
    WebDriverWait(driver, 10).until(EC.url_contains("q-telefon"))
    assert "telefon" in driver.current_url
    assert "warszawa" in driver.current_url
    assert driver.current_url.startswith(BASE_URL)

def test_page_load_time(driver):
    driver.get(BASE_URL)
    start_time = time.time()
    WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CSS_SELECTOR, '[data-testid="search-form"]')))
    end_time = time.time()
    load_time = end_time - start_time
    assert load_time < 5
    assert driver.find_element(By.CSS_SELECTOR, '[data-testid="search-form"]').is_displayed()

def test_search_button(driver):
    search_button = driver.find_element(By.CSS_SELECTOR, "button[data-testid='search-submit']")
    assert search_button.is_displayed()
    assert search_button.find_element(By.TAG_NAME, "svg").is_displayed()
    assert search_button.is_enabled()

def test_search_form_accessibility(driver):
    search_form = driver.find_element(By.CSS_SELECTOR, '[data-testid="search-form"]')
    assert search_form.is_displayed()
    assert search_form.get_attribute("role") != ""
    search_input = driver.find_element(By.ID, "search")
    assert search_input.get_attribute("aria-label") != ""
    location_input = driver.find_element(By.ID, "location-input")
    assert location_input.get_attribute("aria-label") != ""

def test_subcategory_navigation(driver):
    driver.get(BASE_URL + "motoryzacja/")
    subcategory = driver.find_element(By.CSS_SELECTOR, "a[href*='samochody']")
    assert subcategory.is_displayed()
    assert "Samochody osobowe" in subcategory.text
    subcategory.click()
    WebDriverWait(driver, 10).until(EC.url_contains("samochody"))
    assert "samochody" in driver.current_url
    assert driver.current_url.startswith(BASE_URL)

def test_observed_page_link(driver):
    driver.get(BASE_URL)
    observed_link = driver.find_element(By.CSS_SELECTOR, '[data-testid="observed-page-link"]')
    assert observed_link.is_displayed()
    assert observed_link.get_attribute("href").startswith(BASE_URL)
    assert observed_link.is_enabled()
    observed_link.click()
    WebDriverWait(driver, 10).until(EC.url_contains("obserwowane"))
    assert "obserwowane" in driver.current_url

def test_chat_link(driver):
    driver.get(BASE_URL)
    chat_link = WebDriverWait(driver, 10).until(
        EC.presence_of_element_located((By.XPATH, '//a[contains(., "Czat")]'))
    )
    assert chat_link.is_displayed()
    assert chat_link.get_attribute("href").startswith(BASE_URL)
    assert chat_link.is_enabled()