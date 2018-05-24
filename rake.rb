task :import_data => :environment do
  require 'csv'
  batch_size = 100

  (1..34).each do |n|
    n=n.to_s.rjust(2, '0')
    puts "==== 1"
    filename = "/home/puneet/Downloads/Texas contributions tables/contribs_#{n}.csv"
    puts "==== 2"
    total = File.open(filename).count
    puts "==== 3"
    File.open(filename) do |file|
      headers = file.first
      file.lazy.each_slice(batch_size) do |lines|
        csv_rows = CSV.parse(lines.join, write_headers: true, headers: headers)
        csv_rows.each_with_index do |row,i|
          puts "csv: #{i}/#{csv_rows.count}"

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

          if filerName.present? && filerIdent.present? &&  filerTypeCd.present?
            @b=TexasCampaignFinanceCommittee.new
            @b.committee_name = filerName
            @b.committee_number = filerIdent
            @b.type = filerTypeCd
            @b.data_source_state = 'Texas'
            @b.save!
          end

          @c=TexasCampaignFinanceContributor.new
          @c.state = 'Texas'
          @c.name = "#{contributorNameFirst} #{contributorNameLast}"
          @c.job_title = contributorOccupation
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
          d.save!
        end
      end
    end
  end
end  