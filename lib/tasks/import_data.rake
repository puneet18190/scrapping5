task :import_data => :environment do
# require 'pry'
  require 'csv'
  (1..34).each do |n|
    n=n.to_s.rjust(2, '0')
    csv_text = File.read("/home/puneet/Downloads/Texas contributions tables/contribs_#{n}.csv")
    csv = CSV.parse(csv_text, :headers => true)
    arr=[]
    csv.each_with_index do |row,i|
      puts "csv: #{n}, #{i}/#{csv.count}"
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

      # a=TexasCampaignFinanceCandidate.new
      # a.state = 'Texas'
      # a.full_name = candidate_name
      # a.last_name = candidate_name.split(" ").first
      # a.first_name = candidate_name.split(" ").last
      # a.party = party
      # a.full_address = candidate_address
      # a.phone = candidate_phone
      # a.email = candidate_email
      # a.save!
      if filerName.present? && filerIdent.present? &&  filerTypeCd.present?
            @b=TexasCampaignFinanceCommittee.new
            @b.committee_name = filerName
            @b.committee_number = filerIdent
            @b.type = filerTypeCd
            # b.committee_status = committee_status
            # b.election_year = election_year
            # b.candidate_id= a.id
            # b.data_source_url = link
            @b.data_source_state = 'Texas'
            # b.office_sought = office_sought
            # b.election_type = election_type
            # b.register_data = receivedDt
            # b.amended_data = amended_date
            # b.chair_name = chairperson_name
            # b.chair_address = chairperson_address
            # b.treasurer_name = treasurer_name
            # b.treasurer_address = treasurer_address
            # b.party = party
            @b.save!
      end

      @c=TexasCampaignFinanceContributor.new
      @c.state = 'Texas'
      @c.name = "#{contributorNameFirst} #{contributorNameLast}"
      @c.job_title = contributorJobTitle
      @c.employer = contributorEmployer
      @c.city = contributorStreetCity
      @c.state = contributorStreetStateCd
      @c.county = contributorStreetCountryCd
      @c.zip = contributorStreetPostalCode
      @c.address = "#{contributorStreetCity} #{contributorStreetStateCd} #{contributorStreetCountryCd} #{contributorStreetPostalCode}"
      @c.save!

      d=TexasCampaignFinanceContribution.new
      d.source_agency_org = 'Texas Ethics Commission'
      d.source_agency_id = '644535012'
      d.date = contributionDt
      d.amount = contributionAmount
      d.committee_id = @b.try(:id)
      d.contributor_id = @c.try(:id)
      # d.type = schedule_2
      # d.type2 = schedule_1
      d.save!
    end
  end
end