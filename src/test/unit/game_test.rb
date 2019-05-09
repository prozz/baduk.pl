require File.dirname(__FILE__) + '/../test_helper'

class GameTest < Test::Unit::TestCase
  fixtures :games, :users

  VALID_SGF_1 = '(;SZ[19]FF[3]PW[Go Seigen]WR[9d]PB[Takagawa Shukaku]BR[8d]DT[1959-01-09]KM[4.5]RE[B+0.5];B[pd];W[dc];B[dp];W[pq];B[qo];W[pl];B[pn];W[np];B[qq];W[qr];B[pp];W[oq];B[rq];W[jq];B[ce];W[dh];B[cm];W[qf];B[nd];W[rd];B[qc];W[qi];B[gd];W[de];B[dd];W[ed];B[cd];W[eb];B[df];W[ee];B[dg];W[eh];B[ff];W[ef];B[eg];W[fg];B[ch];W[gg];B[gf];W[hf];B[he];W[if];B[jd];W[je];B[gb];W[bc];B[ci];W[kd];B[jc];W[md];B[hg];W[gi];B[ke];W[ne];B[jf];W[od];B[pe];W[oc];B[oe];W[nf];B[og];W[rc];B[pg];W[qb];B[pi];W[pj];B[oj];W[oi];B[ni];W[ph];B[oh];W[pc];B[ig];W[nj];B[pi];W[cf];B[cg];W[oi];B[cc];W[cb];B[pi];W[bf];B[ok];W[oi];B[db];W[da];B[pi];W[dj];B[di];W[oi];B[mj];W[nh];B[pi];W[fe];B[ie];W[oi];B[nk];W[mh];B[pi];W[ej];B[ei];W[oi];B[kp];W[pi];B[kq];W[cj];B[fj];W[fi];B[fk];W[cl];B[dl];W[dm];B[ck];W[bj];B[bl];W[fh];B[hj];W[hi];B[ii];W[bi];B[mq];W[qm];B[nn];W[ij];B[ik];W[jj];B[jp];W[gj];B[hk];W[gk];B[gl];W[fl];B[ek];W[el];B[dk];W[bk];B[cl];W[ji];B[gm];W[li];B[dq];W[kl];B[kn];W[om];B[on];W[jm];B[hn];W[jn];B[jo];W[mr];B[lr];W[mp];B[lp];W[rr];B[sr];W[nr];B[ms];W[nm];B[pm];W[mm];B[ql];W[rl];B[qk];W[pk];B[rm];W[rk];B[qn];W[cn];B[am];W[fn];B[en];W[fm];B[fo];W[hl];B[gn];W[kc];B[ld];W[lc];B[le];W[jb];B[mc];W[nc];B[mb];W[lb];B[me];W[nd];B[la];W[kb];B[ib];W[nb];B[il];W[mn];B[mo];W[lo];B[no];W[ln];B[fc];W[ec];B[ko];W[km];B[ih];W[ge];B[hf];W[bg];B[kh];W[mf];B[fb];W[im];B[hm];W[lg];B[fa];W[in];B[io];W[jk];B[ki];W[kj];B[ja];W[ma];B[sl];W[rj];B[sk];W[sj];B[sm];W[kf];B[jh];W[ak];B[al];W[ka];B[ia];W[jl];B[hl];W[qj];B[qm];W[ns];B[rs];W[ps];B[or];W[lf];B[je];W[kg];B[lh];W[bh];B[hh];W[fd])'
  
  NOT_VALID_SGF_1 = 'cos tam bla bla'
  
  def test_game_saving
    game = Game.new
    game.owner = User.find(1)
    game.description  = "this is short description"
    game.sgf = VALID_SGF_1
    
    assert game.save
    assert_not_nil game.uploaded_at
  end
  
  def test_not_valid_sgf
    game = Game.new
    game.owner = User.find(1)
    game.description = "this is not valid?"
    game.sgf = NOT_VALID_SGF_1
    
    assert !game.save
    assert game.errors.invalid?('sgf')
  end
  
  def test_no_owner
    game = Game.new
    game.description = "lorum ipsum"
    game.sgf = VALID_SGF_1
    
    assert !game.save
    assert game.errors.invalid?('owner')
  end
end
