#https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/ContributorDetails.aspx?o=BjvcCnoPUExqk11Svx5Rbg%253d%253d
#https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/CandidateDetails.aspx?o=pPF7aFQCI%252bYuqYwEcW3VBg%253d%253d
#https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/GroupDetails.aspx?o=fzswkf8JZNTfHp3eVxLPCw%253d%253d
require 'csv'
require 'nokogiri'
require 'open-uri'
require 'metainspector'

# link = "https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/"

link = ["https://www.nvsos.gov/SOSCandidateServices/AnonymousAccess/CEFDSearchUU/CandidateDetails.aspx?o=pPF7aFQCI%252bYuqYwEcW3VBg%253d%253d"]
info = [];
# CSV.open("data.csv","wb") do |record|
link.each_with_index do |l, i|
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

	x=NevadaCampaignFinanceContributor.where(name: contri_name).first
	if x.blank?
		c=NevadaCampaignFinanceContributor.new
	    c.state = 'Nevada'
	    c.name = contri_name
	    c.address = contri_a1
	    c.city = contri_a3
	    c.state = contri_a3.split(" ")[0]
	    c.zip = contri_a3.split(" ")[1]
	    c.save!
	    end

		# rec_link = []
		doc.css("#ctl00_MainContent_dgSearchResults_ctl00 tbody tr").each do |r|
			date = r.css("td")[0].text
			amount = r.css("td")[2].text.scan(/\d/).join
			type = r.css("td")[3].text
			rec_link = r.css("td")[4].children.first.attributes['href'].value
			d=NevadaCampaignFinanceContribution.new
		    d.source_agency_org = 'Nevada Secretary of State'
		    d.source_agency_id = '645758740'
		    d.date = date
		    d.amount = amount
		    # d.committee_id = b.id 
		    d.contributor_id = c.try(:id)
		    d.type = type
		    d.data_source_url = l
		    d.save!
		    end

		    page1 = MetaInspector.new rec_link
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

				a=NevadaCampaignFinanceCandidate.new
			    a.state = 'Nevada'
			    a.full_name = r_name
			    a.last_name = r_name.split(' ').last
			    a.first_name = r_name.split(' ').first
			    a.middle_name = (r_name.split(' ').count > 2 ? r_name.split(' ')[1] : "")
			    a.office_sought = r_offc1
			    a.party = r_party
			    a.full_address = "#{r_address} #{r_city} #{r_state} #{r_zip}"
			    a.address_1 = r_address
			    a.city = r_city
			    a.state = r_state
			    a.zip = r_zip
			    a.phone = r_phone
			    a.email = r_email
			    a.save!
			else
				r_name = doc1.css("#ctl00_MainContent_lblGroupName").text
				r_grouptype = doc1.css("#ctl00_MainContent_lblGroupTypeDesc").text
				r_groupname = doc1.css("#ctl00_MainContent_lblGroupContactName").text
				r_address = doc1.css("#ctl00_MainContent_lblAddress").text
				r_phone = doc1.css("#ctl00_MainContent_lblPhone").text
				r_email = doc1.css("#ctl00_MainContent_lblEmail").text
				r_status = doc1.css("#ctl00_MainContent_lblStatus").text

				b=NevadaCampaignFinanceCommittee.new
			    b.committee_name = r_name
			    # b.candidate_id= a.id
			    b.status = r_status
			    b.chair_name = r_groupname
			    b.chair_address = r_address.split(",").first
			    b.chair_city = r_address.split(',')[1].split(' ').last
			    b.chair_state = r_address.split(',').last.split(' ').first
			    b.chair_zip = r_address.split(',').last.scan(/\d+/).join
			    b.chair_phone = r_phone
			    b.chair_email = r_email
			    b.data_source_url = rec_link
			    b.data_source_state = 'Nevada'
			    b.save!
			    d.update(committee_id:  b.id)
			end
		end
	end
# end

# CSV.open("data1.csv","wb") do |record|
	# rec_link.each do |r_l|
	# 	page1 = MetaInspector.new r_l
	# 	doc1 = page1.parsed
	# 	r_entity = doc1.css("#ctl00_MainContent_lblType").text
		
	# 	if r_entity.include?('Candidate')
	# 		r_name = doc1.css("#ctl00_MainContent_lblCandidateName").text
	# 		r_party = doc1.css("#ctl00_MainContent_lblParty").text
	# 		offc = doc1.css("#ctl00_MainContent_lblOffice").text
	# 		r_offc1 = offc.split(',')[0]
	# 		r_offc2 = offc.split(',')[1]
	# 		r_address = doc1.css("#ctl00_MainContent_lblAddress").text
	# 		r_city = doc1.css("#ctl00_MainContent_lblCity").text
	# 		r_state = doc1.css("#ctl00_MainContent_lblState").text
	# 		r_zip = doc1.css("#ctl00_MainContent_lblZip").text
	# 		r_phone = doc1.css("#ctl00_MainContent_lblPhone").text
	# 		r_email = doc1.css("#ctl00_MainContent_lblEmail").text
	# 	else
	# 		r_name = doc1.css("#ctl00_MainContent_lblGroupName").text
	# 		r_grouptype = doc1.css("#ctl00_MainContent_lblGroupTypeDesc").text
	# 		r_groupname = doc1.css("#ctl00_MainContent_lblGroupContactName").text
	# 		r_address = doc1.css("#ctl00_MainContent_lblAddress").text
	# 		r_phone = doc1.css("#ctl00_MainContent_lblPhone").text
	# 		r_email = doc1.css("#ctl00_MainContent_lblEmail").text
	# 		r_status = doc1.css("#ctl00_MainContent_lblStatus").text
	# 	end
	# end
# end
end