task :import_contributor => :environment do
# require 'pry'
  require 'csv'
  ['2016','2015','2014','2013','2012','2011','2010','2009','2008','2007','2006','2005','2004','2003','2002','2001'].each do |y|
    # y="2017"
    puts "year: #{y}"
    csv_text = File.read("/home/puneet/Desktop/scrap_upwork/2/contributors/ContributionsList#{y}.csv")
    csv = CSV.parse(csv_text, :headers => true)
    arr=[]
    puts y
    m=MarylandCampaignFinanceCommittee.pluck(:committee_name).uniq
    csv.each_with_index do |row,i|
      puts "row: #{i}"
      receiving_committee = row[0]

      if m.include?(receiving_committee)
        a=MarylandCampaignFinanceCommittee.where(committee_name: receiving_committee).first
        if a.present?
          puts "committee_id: #{a.id}"
          filing_period = row[1]
          contribution_date = row[2]
          contributor_name = row[3]
          contributor_address = row[4]
          contributor_type = row[5]
          contribution_type = row[6]
          contribution_amount = row[7]
          employer_name = row[8]
          employer_occupation = row[9]
          office = row[10]
          fundtype = row[11]

          c=MarylandCampaignFinanceContributor.new
          c.state = 'Maryland'
          c.job_title = contributor_type
          # c.employer = contributor_detail
          c.name = contributor_name
          c.address = contributor_address
          c.save!

          d=MarylandCampaignFinanceContribution.new
          d.source_agency_org = 'Maryland State Board of Election'
          d.source_agency_id = '645584429'
          d.date = contribution_date
          d.amount = contribution_amount
          d.committee_id = a.id
          d.contributor_id = c.id
          d.type = contribution_type
          d.save!
        end
      end
    end
  end
end