require 'spec_helper'

describe ExternalLinkHelper do
  let(:user) { build(:user) }

  context '#link_to_github' do
    it 'should generate the link' do
      user = build(:user, github: 'giddiup')
      expect(helper.link_to_github(user)).to eql('<a title="giddiup" href="https://github.com/giddiup">giddiup</a>')
    end

    it 'should generate the link with a block' do
      user = build(:user, github: 'giddiup')
      expect(helper.link_to_github(user) { 'uschi' }).to eql('<a title="giddiup" href="https://github.com/giddiup">uschi</a>')
    end

    it 'should render nothing for no github' do
      user.github = nil
      expect(helper.link_to_github(user)).to be_nil
    end

    it 'generates proper github urls' do
      expect(helper.github_issue_url(123)).to eql('https://github.com/rughh/planning/issues/123')
    end
  end

  context '#link_to_linkedin' do
    it 'should generate the link' do
      user = build(:user, linkedin: 'testyin')
      expect(helper.link_to_linkedin(user)).to eql('<a title="testyin" href="https://www.linkedin.com/in/testyin">testyin</a>')
    end

    it 'should generate the link with a block' do
      user = build(:user, linkedin: 'testyin')
      expect(helper.link_to_linkedin(user) { 'testyin' }).to eql('<a title="testyin" href="https://www.linkedin.com/in/testyin">testyin</a>')
    end

    it 'should render nothing for no linkedin' do
      user.linkedin = nil
      expect(helper.link_to_linkedin(user)).to be_nil
    end
  end

  context '#mailing_list_url' do
    it 'creates an url' do
      expect(helper.mailing_list_url).to eql('https://groups.google.com/group/rubyonrails-ug-germany')
      Whitelabel.with_label(Whitelabel.label_for('cologne')) do
        expect(helper.mailing_list_url).to eql('https://groups.google.com/group/colognerb')
      end
    end
  end

  context '#link_to_twitter' do
    it 'should generate the link' do
      user = build(:user, twitter: 'klaus')
      expect(helper.link_to_twitter(user)).to eql('@<a title="klaus" href="https://twitter.com/klaus">klaus</a>')
    end
  end

  context '#twitter_update_url' do
    let(:topic) { create(:topic, id: 999, name: 'bla') }
    let(:event) { create(:event, name: 'Weihnachtstreffen', date: '2010-12-06 11:47:30') }

    it 'should generate a proper url for topics' do
      topic.user.name = 'Uschi'

      url = helper.twitter_update_url(topic)
      expect(url).to match(Regexp.escape('https://twitter.com/home?status=Neues%20Thema%20von%20@Uschi'))
      expect(url).to match(Regexp.escape('http://test.host/topics/bla-999'))
    end

    it 'should generate a proper url for events' do
      url = helper.twitter_update_url(event)
      expect(url).to match(Regexp.escape('https://twitter.com/home?status=Weihnachtstreffen'))
      expect(url).to match(Regexp.escape('am%2006.%20Dezember,%2011:47%20Uhr'))
      expect(url).to match(Regexp.escape('http://test.host/events/weihnachtstreffen'))
    end
  end
end
