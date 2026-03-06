import requests
import json

# CKAN API 端点
base_url = 'https://www.data.qld.gov.au'
api_endpoint = '/api/3/action/package_show'

# 数据集 ID
package_id = 'school-locations-2024'

# 构建请求 URL
url = base_url + api_endpoint

# 发送请求
response = requests.get(url, params={'id': package_id})

# 解析响应
if response.status_code == 200:
    data = response.json()
    
    if data.get('success'):
        package = data.get('result', {})
        resources = package.get('resources', [])
        
        print('Available resources:')
        for i, resource in enumerate(resources):
            print(f"{i+1}. {resource.get('name')} ({resource.get('format')})")
            print(f"   URL: {resource.get('url')}")
            print()
        
        # 找到 CSV 格式的资源
        csv_resources = [r for r in resources if r.get('format', '').lower() == 'csv']
        
        if csv_resources:
            csv_resource = csv_resources[0]
            csv_url = csv_resource.get('url')
            print(f'Downloading CSV from: {csv_url}')
            
            # 下载 CSV 文件
            csv_response = requests.get(csv_url)
            
            with open('data/qld_schools.csv', 'wb') as f:
                f.write(csv_response.content)
            
            print(f'Downloaded {len(csv_response.content)} bytes to data/qld_schools.csv')
        else:
            print('No CSV resources found')
    else:
        print('API request failed:', data.get('error', {}))
else:
    print('HTTP request failed:', response.status_code)
