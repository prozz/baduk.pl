# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

module SpecHelper
  def check_saving_has_errors(entity, field, errors_no)
    lambda { entity.save! }.should raise_error
    entity.should have_at_least(errors_no).error_on(field)
  end
  def valid_game_attributes # {{{ 
    { 
      :id => 1,
      :sgf => '(;SZ[19]FF[3]PW[Go Seigen]WR[9d]PB[Takagawa Shukaku]BR[8d]DT[1959-01-09]KM[4.5]RE[B+0.5];B[pd];W[dc];B[dp];W[pq];B[qo];W[pl];B[pn];W[np];B[qq];W[qr];B[pp];W[oq];B[rq];W[jq];B[ce];W[dh];B[cm];W[qf];B[nd];W[rd];B[qc];W[qi];B[gd];W[de];B[dd];W[ed];B[cd];W[eb];B[df];W[ee];B[dg];W[eh];B[ff];W[ef];B[eg];W[fg];B[ch];W[gg];B[gf];W[hf];B[he];W[if];B[jd];W[je];B[gb];W[bc];B[ci];W[kd];B[jc];W[md];B[hg];W[gi];B[ke];W[ne];B[jf];W[od];B[pe];W[oc];B[oe];W[nf];B[og];W[rc];B[pg];W[qb];B[pi];W[pj];B[oj];W[oi];B[ni];W[ph];B[oh];W[pc];B[ig];W[nj];B[pi];W[cf];B[cg];W[oi];B[cc];W[cb];B[pi];W[bf];B[ok];W[oi];B[db];W[da];B[pi];W[dj];B[di];W[oi];B[mj];W[nh];B[pi];W[fe];B[ie];W[oi];B[nk];W[mh];B[pi];W[ej];B[ei];W[oi];B[kp];W[pi];B[kq];W[cj];B[fj];W[fi];B[fk];W[cl];B[dl];W[dm];B[ck];W[bj];B[bl];W[fh];B[hj];W[hi];B[ii];W[bi];B[mq];W[qm];B[nn];W[ij];B[ik];W[jj];B[jp];W[gj];B[hk];W[gk];B[gl];W[fl];B[ek];W[el];B[dk];W[bk];B[cl];W[ji];B[gm];W[li];B[dq];W[kl];B[kn];W[om];B[on];W[jm];B[hn];W[jn];B[jo];W[mr];B[lr];W[mp];B[lp];W[rr];B[sr];W[nr];B[ms];W[nm];B[pm];W[mm];B[ql];W[rl];B[qk];W[pk];B[rm];W[rk];B[qn];W[cn];B[am];W[fn];B[en];W[fm];B[fo];W[hl];B[gn];W[kc];B[ld];W[lc];B[le];W[jb];B[mc];W[nc];B[mb];W[lb];B[me];W[nd];B[la];W[kb];B[ib];W[nb];B[il];W[mn];B[mo];W[lo];B[no];W[ln];B[fc];W[ec];B[ko];W[km];B[ih];W[ge];B[hf];W[bg];B[kh];W[mf];B[fb];W[im];B[hm];W[lg];B[fa];W[in];B[io];W[jk];B[ki];W[kj];B[ja];W[ma];B[sl];W[rj];B[sk];W[sj];B[sm];W[kf];B[jh];W[ak];B[al];W[ka];B[ia];W[jl];B[hl];W[qj];B[qm];W[ns];B[rs];W[ps];B[or];W[lf];B[je];W[kg];B[lh];W[bh];B[hh];W[fd])', 
      :owner => User.new(valid_user_attributes), 
      :description => 'this is pretty standard game description'
    }  
  end # }}}
  def valid_user_attributes # {{{
    { :login => "foo",
      :email => "foo@baduk.pl",
      :password => "secret!",
      :password_confirmation => "secret!",
      :created_at => Time.now
    }
  end # }}}
  def valid_player_attributes # {{{
    { 'name' => 'x', 
      'surname' => 'x',
      'email' => 'x@baduk.pl',
      'rank' => '13 kyu'
    }
  end # }}}
end

Spec::Runner.configure do |config|
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  # == Fixtures
  #
  # You can declare fixtures for each example_group like this:
  #   describe "...." do
  #     fixtures :table_a, :table_b
  #
  # Alternatively, if you prefer to declare them only once, you can
  # do so right here. Just uncomment the next line and replace the fixture
  # names with your fixtures.
  #
  # config.global_fixtures = :table_a, :table_b
  #
  # If you declare global fixtures, be aware that they will be declared
  # for all of your examples, even those that don't use them.
  #
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

