import requests
from bs4 import BeautifulSoup

# 获取学校位置数据页面
url = 'https://www.data.qld.gov.au/dataset/school-locations-2024'
response = requests.get(url)

# 解析页面内容
soup = BeautifulSoup(response.text, 'html.parser')

# 查找 CSV 下载链接
csv_links = []
for link in soup.find_all('a', href=True):
    href = link['href']
    if href.endswith('.csv'):
        csv_links.append(href)

print('Found CSV links:')
for link in csv_links:
    print(link)

# 尝试下载第一个 CSV 文件
if csv_links:
    csv_url = csv_links[0]
    # 如果是相对路径，添加基础 URL
    if not csv_url.startswith('http'):
        csv_url = 'https://www.data.qld.gov.au' + csv_url
    
    print(f'\nDownloading from: {csv_url}')
    csv_response = requests.get(csv_url)
    
    with open('data/qld_schools.csv', 'wb') as f:
        f.write(csv_response.content)
    
    print(f'Downloaded {len(csv_response.content)} bytes to data/qld_schools.csv')
else:
    print('No CSV links found')
