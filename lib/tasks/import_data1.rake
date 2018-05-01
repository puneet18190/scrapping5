task :import_data1 => :environment do
# require 'pry'
  require 'csv'
  # csv_text = File.read('/home/puneet/Downloads/Contributions_to_Candidates_and_Political_Committees.csv')
  # csv = CSV.parse(csv_text, :headers => true)
  # arr=[]
  require 'soda/client'
  count=843000
  client = SODA::Client.new({:domain => "data.wa.gov", :app_token => "ex5wJvWzJfDh0bvGKZSdy82LW"})

  (843..950).each do |n|
    #offset = (n==0 ? 1 : (n*1000))
    offset = n*1000
  results = client.get("74eq-kst5",:$offset => offset, :$limit => 1000)
  # csv.each_with_index do |row,i|
  results.each_with_index do |row,i|
    count=count+1
    puts "#{i} #{count} #{offset}"

    id = row.id #1807835.rcpt
    report_number = row.report_number #100218469
    origin = row.origin #C3
    filer_id = row.filer_id #HUNTS 506
    type = row.type #Candidate
    filer_name = row.filer_name #HUNT SAMUEL W
    first_name = row.first_name #SAMUEL
    middle_initial = row.middle_initial #W
    last_name = row.last_name #HUNT
    office = row.office #STATE REPRESENTATIVE
    legislative_district = row.legislative_district #22
    position = row.position #2
    party = row.party #DEMOCRAT
    ballot_number = row.ballot_number #"" 
    for_or_against = row.for_or_against #""
    jurisdiction = row.jurisdiction #LEG DISTRICT 22 - HOUSE
    jurisdiction_county = row.jurisdiction_county #THURSTON 
    jurisdiction_type = row.jurisdiction_type #Legislative
    election_year = row.election_year #2008
    amount = row.amount #$250.00
    cash_or_in_kind = row.cash_or_in_kind #Cash
    receipt_date = row.receipt_date #07/02/2007
    description = row.description #""
    memo = row.memo #"" 
    primary_general = row.primary_general #Primary
    code = row.code #Political Action Committee
    contributor_name = row.contributor_name #SQUAXIN
    contributor_address = row.contributor_address #10 SE SQUAXIN LN 
    contributor_city = row.contributor_city #SHELTON
    contributor_state = row.contributor_state #WA
    contributor_zip = row.contributor_zip #98584
    contributor_occupation = row.contributor_occupation #"" 
    contributor_employer_name = row.contributor_employer_name #"" 
    contributor_employer_city = row.contributor_employer_city #"" 
    contributor_employer_state = row.contributor_employer_state #"" 
    url  = row.url #View report (http =/row.http #/web.pdc.wa.gov/rptimg/default.aspx?batchnumber=100218469)
    contributor_location = row.contributor_location #(47.12187, -123.08012)
    link = "https://data.wa.gov/Politics/Contributions-to-Candidates-and-Political-Committe/kv7h-kjye/data"

    a=WashingtonCampaignFinanceCandidate.new
    a.state = 'Washington'
    a.full_name = "#{first_name} #{middle_initial} #{last_name}"
    a.last_name = last_name
    a.first_name = first_name
    a.middle_name = middle_initial
    a.office_sought = office
    a.party = party
    a.county = jurisdiction_county
    a.save!

    if filer_name.present? || filer_id.present? || type.present? || legislative_district.present? || party.present? || jurisdiction_county.present? || election_year.present?
    b=WashingtonCampaignFinanceCommittee.new
    b.committee_name = filer_name #committee_name
    b.committee_number = filer_id
    b.type = type
    b.district = legislative_district
    b.party = party
    b.county = jurisdiction_county
    b.candidate_id= a.id
    b.data_source_url = link
    b.data_source_state = 'Washington'
    b.election_year = election_year
    b.save!
    end

    if contributor_name.present? || contributor_address.present? || contributor_employer_name.present? || contributor_occupation.present?
    c=WashingtonCampaignFinanceContributor.new
    c.state = 'Washington'
    c.name = contributor_name
    c.address = contributor_address
    c.city = contributor_city
    c.state = contributor_state
    c.zip = contributor_zip
    c.job_title = contributor_occupation
    c.employer = contributor_employer_name
    c.save!
    end

    if c.present? && b.present?
    d=WashingtonCampaignFinanceContribution.new
    d.source_agency_org = 'State of Washington'
    d.source_agency_id = '645047912'
    d.date = receipt_date
    d.amount = (amount.nil? ? "" : amount.gsub("$","").gsub("(","").gsub(")",""))
    d.committee_id = b.id 
    d.contributor_id = c.id
    d.type = cash_or_in_kind
    d.type2 = code
    d.data_source_url = link
    d.save!
    end
  end
end
end