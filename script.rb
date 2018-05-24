#https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/ContributorDetails.aspx?o=BjvcCnoPUExqk11Svx5Rbg%253d%253d
#https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/CandidateDetails.aspx?o=pPF7aFQCI%252bYuqYwEcW3VBg%253d%253d
#https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/GroupDetails.aspx?o=fzswkf8JZNTfHp3eVxLPCw%253d%253d
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'metainspector'

link = "https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/"

info = [];
CSV.open("data.csv","wb") do |record|
	page = MetaInspector.new l
	doc = page.parsed
	contri_name = doc.css("#ctl00_MainContent_lblContactName").text
	address = doc.css("#ctl00_MainContent_lblContactAddress").text
	contri_a1 = doc.css("#ctl00_MainContent_lblContactAddress").children[0].text
	contri_a2 = doc.css("#ctl00_MainContent_lblContactAddress").children[1].text
	a3 = doc.css("#ctl00_MainContent_lblContactAddress").children[2].text
	contri_a3 = a3.split(",")[0]
	contri_a4 = a3.split(",")[1]
	contri_total = doc.css("#ctl00_MainContent_lblContTotal").text.scan(/\d+/).join

	c=NevadaCampaignFinanceContributor.new
    c.state = 'Nevada'
    c.name = contri_name
    c.address = address
    c.city = contributor_city
    c.state = contributor_state
    c.zip = contributor_zip
    # c.job_title = contributor_occupation
    # c.employer = contributor_employer_name
    c.save!
    end

	rec_link = []
	doc.css("#ctl00_MainContent_dgSearchResults_ctl00 tbody tr").each do |r|
		date = r.css("td")[0].text
		amount = r.css("td")[2].text.scan(/\d/).join
		type = r.css("td")[3].text
		rec_link << r.css("td")[4].children.first.attributes['href'].value
	end
end

CSV.open("data1.csv","wb") do |record|
	rec_link.each do |r_l|
		page1 = MetaInspector.new r_l
		doc1 = page1.parsed
		r_entity = doc1.css("#ctl00_MainContent_lblType").text
		
		if r_entity.include?('Candidate')
			r_name = doc1.css("#ctl00_MainContent_lblCandidateName").text
			r_party = doc1.css("#ctl00_MainContent_lblParty").text
			offc = doc1.css("#ctl00_MainContent_lblOffice").text
			r_offc1 = offc.split(',')[0]
			r_offc2 = offc.split(',')[1]
			r_address = doc1.css("#ctl00_MainContent_lblAddress").text
			r_city = doc1.css("#ctl00_MainContent_lblCity").text
			r_state = doc1.css("#ctl00_MainContent_lblState").text
			r_zip = doc1.css("#ctl00_MainContent_lblZip").text
			r_phone = doc1.css("#ctl00_MainContent_lblPhone").text
			r_email = doc1.css("#ctl00_MainContent_lblEmail").text
		else
			r_name = doc1.css("#ctl00_MainContent_lblGroupName").text
			r_grouptype = doc1.css("#ctl00_MainContent_lblGroupTypeDesc").text
			r_groupname = doc1.css("#ctl00_MainContent_lblGroupContactName").text
			r_address = doc1.css("#ctl00_MainContent_lblAddress").text
			r_phone = doc1.css("#ctl00_MainContent_lblPhone").text
			r_email = doc1.css("#ctl00_MainContent_lblEmail").text
			r_status = doc1.css("#ctl00_MainContent_lblStatus").text
		end
	end
end