require File.dirname(__FILE__) + '/../spec_helper'

include SpecHelper

describe ApplicationHelper, "while helping with parsing sgf" do # {{{
  before :all do
    @game = Game.new
    @game.sgf = '(;SZ[19]FF[3]PW[Go Seigen]WR[9d]PB[Takagawa Shukaku]BR[8d]DT[1959-01-09]KM[4.5]RE[B+0.5];B[pd];W[dc];B[dp];W[pq];B[qo];W[pl];B[pn];W[np];B[qq];W[qr];B[pp];W[oq];B[rq];W[jq];B[ce];W[dh];B[cm];W[qf];B[nd];W[rd];B[qc];W[qi];B[gd];W[de];B[dd];W[ed];B[cd];W[eb];B[df];W[ee];B[dg];W[eh];B[ff];W[ef];B[eg];W[fg];B[ch];W[gg];B[gf];W[hf];B[he];W[if];B[jd];W[je];B[gb];W[bc];B[ci];W[kd];B[jc];W[md];B[hg];W[gi];B[ke];W[ne];B[jf];W[od];B[pe];W[oc];B[oe];W[nf];B[og];W[rc];B[pg];W[qb];B[pi];W[pj];B[oj];W[oi];B[ni];W[ph];B[oh];W[pc];B[ig];W[nj];B[pi];W[cf];B[cg];W[oi];B[cc];W[cb];B[pi];W[bf];B[ok];W[oi];B[db];W[da];B[pi];W[dj];B[di];W[oi];B[mj];W[nh];B[pi];W[fe];B[ie];W[oi];B[nk];W[mh];B[pi];W[ej];B[ei];W[oi];B[kp];W[pi];B[kq];W[cj];B[fj];W[fi];B[fk];W[cl];B[dl];W[dm];B[ck];W[bj];B[bl];W[fh];B[hj];W[hi];B[ii];W[bi];B[mq];W[qm];B[nn];W[ij];B[ik];W[jj];B[jp];W[gj];B[hk];W[gk];B[gl];W[fl];B[ek];W[el];B[dk];W[bk];B[cl];W[ji];B[gm];W[li];B[dq];W[kl];B[kn];W[om];B[on];W[jm];B[hn];W[jn];B[jo];W[mr];B[lr];W[mp];B[lp];W[rr];B[sr];W[nr];B[ms];W[nm];B[pm];W[mm];B[ql];W[rl];B[qk];W[pk];B[rm];W[rk];B[qn];W[cn];B[am];W[fn];B[en];W[fm];B[fo];W[hl];B[gn];W[kc];B[ld];W[lc];B[le];W[jb];B[mc];W[nc];B[mb];W[lb];B[me];W[nd];B[la];W[kb];B[ib];W[nb];B[il];W[mn];B[mo];W[lo];B[no];W[ln];B[fc];W[ec];B[ko];W[km];B[ih];W[ge];B[hf];W[bg];B[kh];W[mf];B[fb];W[im];B[hm];W[lg];B[fa];W[in];B[io];W[jk];B[ki];W[kj];B[ja];W[ma];B[sl];W[rj];B[sk];W[sj];B[sm];W[kf];B[jh];W[ak];B[al];W[ka];B[ia];W[jl];B[hl];W[qj];B[qm];W[ns];B[rs];W[ps];B[or];W[lf];B[je];W[kg];B[lh];W[bh];B[hh];W[fd])'

    @another_game = Game.new
    @another_game.sgf = '(;SZ[19]FF[3]PW[A. K.]WR[9d]PB[]HA[5])'

    @honinbo = Game.new
    @honinbo.sgf = 'BR[9p]PW[Takao Shinji]WR[9p,Honinbo]KM[6.5]'
  end

  it "should recognize white player" do
    sgf_white_player(@game).should eql('Go Seigen')
    sgf_white_player(@another_game).should eql('A. K.')
  end
  it "should recognize white player's rank" do
    sgf_white_rank(@game).should eql('9d')
  end
  it "should recognize black player" do
    sgf_black_player(@game).should eql('Takagawa Shukaku')
  end
  it "should recognize black player's rank" do
    sgf_black_rank(@game).should eql('8d')
    sgf_black_rank(@honinbo).should eql('9p')
    sgf_white_rank(@honinbo).should eql('9p,Honinbo')
  end
  it "should recognize result of the whole game" do
    sgf_result(@game).should eql('B+0.5')
  end
  it "should recognize komi value" do
    sgf_komi(@game).should eql('4.5')
  end
  it "should recognize board size" do
    sgf_board_size(@game).should eql('19')
  end
  it "should recognize handicap" do
    sgf_handicap(@game).should eql('?')
    sgf_handicap(@another_game).should eql('5')
  end
end # }}}

describe ApplicationHelper, "while helping with user" do # {{{
  it "should tell if user is authorized" do
    user?.should == false
    session[:user] = User.new valid_user_attributes
    user?.should == true
  end
end # }}}

describe ApplicationHelper, "while helping with forms" do # {{{
  include Technoweenie::LabeledFormHelper

  it "should print inputs with labels" do
    input = form_input('player', 'name', 'Imię:', 28, 2)
    input.should match(/<label for="player_name"/)
    input.should match(/<input/)
    input.should match(/type="text"/)
    input.should match(/Imię:<\/label>/)
    input.should match(/id="player_name"/)
    input.should match(/size="28"/)
    input.should match(/tabindex="2"/)
  end
  it "should print plain inputs with labels (if you're not binding to object)" do
    input = form_plain_input('tag', 'Tag:', 28, 2)
    input.should match(/<label for="tag"/)
    input.should match(/<input/)
    input.should match(/type="text"/)
    input.should match(/Tag:<\/label>/)
    input.should match(/id="tag"/)
    input.should match(/size="28"/)
    input.should match(/tabindex="2"/)
  end
  it "should print file inputs with labels" do
    input = form_file('game', 'sgf', 'SGF:', 28, 2)
    input.should match(/<label for="game_sgf"/)
    input.should match(/<input/)
    input.should match(/type="file"/)
    input.should match(/SGF:<\/label>/)
    input.should match(/id="game_sgf"/)
    input.should match(/size="28"/)
    input.should match(/tabindex="2"/)
  end
  it "should print password inputs with labels" do
    input = form_password('player', 'password', 'Password:', 28, 2)
    input.should match(/<label for="player_password"/)
    input.should match(/<input/)
    input.should match(/type="password"/)
    input.should match(/Password:<\/label>/)
    input.should match(/id="player_password"/)
    input.should match(/size="28"/)
    input.should match(/tabindex="2"/)
  end
  it "should print selects with labels" do
    select = form_select('player', 'rank', 'Ranking:', 1, ['a', 'b'])
    select.should match(/<label for="player_rank"/)
    select.should match(/<select/)
    select.should match(/Ranking:<\/label>/)
    select.should match(/tabindex="1"/)
    select.should match(/value="a"/)
    select.should match(/value="b"/)
    select.should match(/b<\/option>/)
  end
  it "should print text areas with labels" do
    textarea = form_textarea('game', 'sgf', 'SGF', 20, 10, 1)
    textarea.should match(/<label for="game_sgf"/)
    textarea.should match(/<textarea/)
    textarea.should match(/SGF<\/label>/)
    textarea.should match(/tabindex="1"/)
  end
  it "should print plain text areas with labels (if you're not binding to object)" do
    textarea = form_plain_textarea('comment', 'Comment', 20, 10, 1)
    textarea.should match(/<label for="comment"/)
    textarea.should match(/<textarea/)
    textarea.should match(/Comment<\/label>/)
    textarea.should match(/tabindex="1"/)
  end


end # }}}

describe ApplicationHelper, "while helping with game result recognition" do # {{{
	
  it "should replace result with appropriate icon" do
    @game = Game.new(:sgf => '...-09]KM[4.5]RE[B+0.5];B[pd];W[d...')
    sgf_result_with_icons(@game).should eql('<span class="game_result"><img src="/player/images/b.png">+0.5</span>')
    
    @game = Game.new(:sgf => '...-09]KM[4.5]RE[W+15];B[pd];W[d...')
    sgf_result_with_icons(@game).should eql('<span class="game_result"><img src="/player/images/w.png">+15</span>')
  end
  
  it "should take care of different form of 'resign' word" do
    @game_A = Game.new(:sgf => '...-09]KM[4.5]RE[B+R];B[pd];W[d...')
    @game_B = Game.new(:sgf => '...-09]KM[4.5]RE[B+ Resign];B[pd];W[d...')
    @game_C = Game.new(:sgf => '...-09]KM[4.5]RE[B+r ];B[pd];W[d...')
    @game_D = Game.new(:sgf => '...-09]KM[4.5]RE[ B+ resign ];B[pd];W[d...')
    sgf_result_with_icons(@game_A).should eql(sgf_result_with_icons(@game_B))
    sgf_result_with_icons(@game_B).should eql(sgf_result_with_icons(@game_C))
    sgf_result_with_icons(@game_C).should eql(sgf_result_with_icons(@game_D))
  end

  it "should recognize loosing by 'time'" do
    @game_A = Game.new(:sgf => '...-09]KM[4.5]RE[B+Time];B[pd];W[d...')
    @game_B = Game.new(:sgf => '...-09]KM[4.5]RE[B+ Time ];B[pd];W[d...')
    @game_C = Game.new(:sgf => '...-09]KM[4.5]RE[B+T ];B[pd];W[d...')
    @game_D = Game.new(:sgf => '...-09]KM[4.5]RE[ B+ time ];B[pd];W[d...')
    sgf_result_with_icons(@game_A).should eql(sgf_result_with_icons(@game_B))
    sgf_result_with_icons(@game_B).should eql(sgf_result_with_icons(@game_C))
    sgf_result_with_icons(@game_C).should eql(sgf_result_with_icons(@game_D))
    sgf_result_with_icons(@game_A).should match(/\+T/)
  end
  
end # }}}
