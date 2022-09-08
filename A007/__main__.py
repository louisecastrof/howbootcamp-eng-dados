import time
from selenium import webdriver
import selenium

#%%
#Acesso ao site da HowEdu
driver.get("https://howedu.com.br/")
time.sleep(2)
driver.find_element("xpath", '//*[@id="adopt-accept-all-button"]').click()
#%%


driver = webdriver.Chrome("/usr/bin/chromedriver")
driver.get("https://buscacepinter.correios.com.br/app/endereco/index.php")
elem_cep = driver.find_element("name", "endereco")
elem_cep.clear()
elem_cep.send_keys('Rua São Mateus')
elem_cmb = driver.find_element("name", "tipoCEP")
elem_cmb.click()
elem_cep = driver.find_element("xpath", '/html/body/main/form/div[1]/div[1]/div/section/div[2]/div/div[2]/select/optgroup/option[1]').click()
elem_busca = driver.find_element("xpath", '/html/body/main/form/div[1]/div[1]/div/section/div[3]/div/div/button').click()
print(logradouro = driver.find_element("xpath", '//*[@id="resultado-DNEC"]/thead/tr/th[1]').text)
# logradouro.split('-')[0]
# logradouro
