task :import_data => :environment do
# require 'pry'
  require 'csv'
  csv_text = File.read('/home/puneet/Puneet/upwork/scrap_app2/public/data.csv')
  csv = CSV.parse(csv_text, :headers => true)
  arr=[]
  csv.each_with_index do |row,i|
    puts i
    recordType = row[0]
    formTypeCd = row[1]
    schedFormTypeCd = row[2]
    reportInfoIdent = row[3]
    receivedDt = row[4]
    infoOnlyFlag = row[5]
    filerIdent = row[6]
    filerTypeCd = row[7]
    filerName = row[8]
    contributionInfoId = row[9]
    contributionDt = row[10]
    contributionAmount = row[11]
    contributionDescr = row[12]
    itemizeFlag = row[13]
    travelFlag = row[14]
    contributorPersentTypeCd = row[15]
    contributorNameOrganization = row[16]
    contributorNameLast = row[17]
    contributorNameSuffixCd = row[18]
    contributorNameFirst = row[19]
    contributorNamePrefixCd = row[20]
    contributorNameShort = row[21]
    contributorStreetCity = row[22]
    contributorStreetStateCd = row[23]
    contributorStreetCountyCd = row[24]
    contributorStreetCountryCd = row[25]
    contributorStreetPostalCode = row[26]
    contributorStreetRegion = row[27]
    contributorEmployer = row[28]
    contributorOccupation = row[29]
    contributorJobTitle = row[30]
    contributorPacFein = row[31]
    contributorOosPacFlag = row[32]
    contributorSpouseLawFirmName = row[33]
    contributorParent1LawFirmName = row[34]
    contributorParent2LawFirmName = row[35]

    # committee_type = row[0]
    # committee_id = row[1]
    # committee_name = row[2]
    # committee_status = row[3]
    # election_type = row[4]
    # registered_date = row[5]
    # amended_date = row[6]
    # chairperson_name = row[7]
    # chairperson_address = row[8]
    # treasurer_name = row[9]
    # treasurer_address = row[10]
    # candidate_name = row[11]
    # candidate_dob = row[12]
    # candidate_email = row[13]
    # candidate_address1 = row[14]
    # candidate_address2 = row[15]
    # candidate_pin = row[17]
    # candidate_address = "#{row[14]} #{row[15]} #{row[16]} #{row[17]}"
    # candidate_phone = row[18]
    # election_year = row[19]
    # office_type = row[21]
    # office_sought = row[22]
    # jurisdiction = row[23]
    # party = row[24]
    # link = "https://campaignfinancemd.us/Public/ShowReview?memberID=#{row[1].last(5).to_i}%20&memVersID=100%20&cTypeCode=01"

    a=TexasCampaignFinanceCandidate.new
    a.state = 'Texas'
    a.full_name = candidate_name
    a.last_name = candidate_name.split(" ").first
    a.first_name = candidate_name.split(" ").last
    a.party = party
    a.full_address = candidate_address
    a.phone = candidate_phone
    a.email = candidate_email
    a.save!

    b=TexasCampaignFinanceCommittee.new
    b.committee_name = committee_name
    b.committee_number = committee_id
    b.committee_type = committee_type
    b.committee_status = committee_status
    b.election_year = election_year
    b.candidate_id= a.id
    b.data_source_url = link
    b.data_source_state = 'Texas'
    b.office_sought = office_sought
    b.election_type = election_type
    b.register_data = registered_date
    b.amended_data = amended_date
    b.chair_name = chairperson_name
    b.chair_address = chairperson_address
    b.treasurer_name = treasurer_name
    b.treasurer_address = treasurer_address
    b.party = party
    b.save!

    c=TexasCampaignFinanceContributor.new
    c.state = 'Texas'
    c.job_title = ""
    c.employer = contributor_detail
    c.name = contributor
    c.save!

    d=TexasCampaignFinanceContribution.new
    d.source_agency_org = 'State of Washington'
    d.source_agency_id = '645047912'
    d.date = date
    d.amount = amount.to_f
    d.committee_id = b.id 
    d.contributor_id = c.id
    d.type = schedule_2
    d.type2 = schedule_1
    d.save!
  end
end