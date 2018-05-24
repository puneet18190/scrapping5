task :scrap2 => :environment do
# require 'pry'
  require 'csv'
  require 'nokogiri'
  # batch_size = 100

  # [[2017,6],[2016,5]].each do |n|
    puts "==== 1"
    # s=n[1].to_i
    [6].each do |z|
      # z=z+1
      filename = "/home/puneet/Downloads/Missouri/2017/#{z}.html"
      doc=Nokogiri::HTML(open(filename));

      a=doc.css('#ContentPlaceHolder_grvContr11 tr');
      total=a.count
      (1..a.count).each do |b|
        puts "2017 #{z} #{b}/#{total}"
        # if n[0]!=2017 || (n[0]==2017 && z!=1) || (n[0]==2017 && z==1 && b>28941)
        c=a[b]
        if c.present?
            mecid = c.css("td")[0].text
            committee = c.css("td")[1].text
            report = c.css("td")[2].text
            contri_committee = c.css("td")[3].text
            contri_company = c.css("td")[4].text
            contri_lastname = c.css("td")[5].text
            contri_firstname = c.css("td")[6].text
            address1 = c.css("td")[7].text
            address2 = c.css("td")[8].text
            city = c.css("td")[9].text
            state = c.css("td")[10].text
            zip = c.css("td")[11].text
            employer = c.css("td")[12].text
            occupation = c.css("td")[13].text
            date = c.css("td")[14].text
            date="#{date.split('/')[1]}/#{date.split('/')[0]}/#{date.split('/')[2]}" if date.present?
            amount = c.css("td")[15].text
            amount=amount.scan(/\d+/).first if amount.present?
            type = c.css("td")[16].text
            link = "https://mec.mo.gov/mec/Campaign_Finance/CF12_ContrExpend.aspx"

            @b=MissouriCountiesCampaignFinanceCommittee.new
            @b.committee_name = committee
            @b.committee_number = mecid
            @b.data_source_state = 'Missouri'
            @b.save!

            @c=MissouriCountiesCampaignFinanceContributor.new
            @c.state = 'Missouri'
            @c.name = "#{contri_firstname} #{contri_lastname}"
            @c.job_title = occupation
            @c.employer = employer
            @c.city = city
            @c.state = state
            @c.zip = zip
            @c.address = "#{address1} #{address2} #{city} #{state} #{zip}"
            @c.save!

            @d=MissouriCountiesCampaignFinanceContribution.new
            @d.source_agency_org = 'Missouri Ethics Commission'
            @d.source_agency_id = '645602124'
            @d.date = date
            @d.amount = amount
            @d.type = type
            @d.committee_id = @b.try(:id)
            @d.contributor_id = @c.try(:id)
            @d.data_source_url = link
            @d.save!
      end
    end
  end
end  