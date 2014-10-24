
require "mechanize"
require "nokogiri"

a = Mechanize.new
a.user_agent_alias = 'Mac Safari'

#同一个User agent，维持登陆session
a.get("http://www.58food.com/member/login.php") do |page|
    f = page.form_with(:action=>"login.php")
    username = f.field_with(:name=>"username")
    username.value = "dotcomxy"
    password = f.field_with(:name=>"password")

    #账户密码是4742488， 但提交表单的时候，58food会调用前端的代码进行md5加密，所以post request中看到的是下面的值
    password.value = "1f2fc9539c4a686b62133d1e5c81555c"

    #登陆后希望回到主页，而不是进入商务室，所以uncheck goto
    checkbox = f.checkbox_with(:name=>"goto")
    checkbox.uncheck
    a.submit(f)

    #其中的一个经销商例子页面
    page = a.get("http://www.58food.com/company_lzx108747638.html") 
    document = Nokogiri::HTML(page.content)
    tables = document.search("table")

    #我们想爬公司信息和联系人信息，根据它的页面结构分别是table 2 和 table 4
    company_info_trs = tables[2].search("tr")

    company_info_trs.each do |tr|
      tr.search("td").each_slice(2) do |tds|
        puts "#{tds[0].text}: #{tds[1].text}"
      end
    end

    contact_info_trs = tables[4].search("tr")

    contact_info_trs.each do |tr|
      tr.search("td").each_slice(2) do |tds|
        puts "#{tds[0].text}: #{tds[1].text}"
      end
    end
    
end

