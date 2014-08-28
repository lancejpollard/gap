CUTOFF := 100;



KaratsubaTaskedInner := function(cf, cg)
    local  deg, n, cf1, cg1, cf2, cg2, sf, sg, p1, p2, p3, x1, x2, x3, 
           mo, o, z, i, m, y;

    deg := Maximum(Length(cf), Length(cg));
    if deg <= CUTOFF then
        return ProductCoeffs(cf,Length(cf),cg, Length(cg));
    fi;
    n := QuoInt(deg,2);
    cf1 := `cf{[1..n]};
    cg1 := `cg{[1..n]};
    cf2 := `cf{[n+1..Length(cf)]};
    cg2 := `cg{[n+1..Length(cg)]};
    sf := cf1 + cf2;
    sg := cg1 + cg2;
    p1 := RunTask(KaratsubaTaskedInner, cf1, cg1);
    p2 := RunTask(KaratsubaTaskedInner, cf2, cg2);
    p3 := RunTask(KaratsubaTaskedInner, sf, sg);
    x1 := TaskResult(p1);
    x2 := TaskResult(p2);
    x3 := TaskResult(p3);
    mo := -One(cf[1]);
    o := One(cf[1]);
    z := Zero(cf[1]);
    AddCoeffs(x3,x1,mo);
    AddCoeffs(x3,x2,mo);
    m := Maximum(Length(x1), Length(x2)+ 2*n, Length(x3)+n);
    y := ListWithIdenticalEntries(m,z);
    AddCoeffs(y,x1);
    AddCoeffs(y, [2*n+1..2*n+Length(x2)], x2,[1..Length(x2)],o);
    AddCoeffs(y, [n+1..n+Length(x3)],x3,[1..Length(x3)],o);
    return y;    
end;

KaratsubaSeqInner := function(cf, cg)
    local  deg, n, mo, cf1, cg1, cf2, cg2, sf, sg, p1, p2, p3, x1, x2, 
           x3;
    deg := Maximum(Length(cf), Length(cg));
    if deg <= CUTOFF then
        return ProductCoeffs(cf,Length(cf),cg, Length(cg));
    fi;
    n := QuoInt(deg,2);
    mo := -One(cf[1]);
    cf1 := `cf{[1..n]};
    cg1 := `cg{[1..n]};
    cf2 := `cf{[n+1..Length(cf)]};
    cg2 := `cg{[n+1..Length(cg)]};
    sf := cf1 + cf2;
    sg := cg1 + cg2;
    x1 := KaratsubaSeqInner( cf1, cg1);
    x2 := KaratsubaSeqInner( cf2, cg2);
    x3 := KaratsubaSeqInner(sf, sg);
    AddCoeffs(x3,x1,mo);
    AddCoeffs(x3,x2,mo);
    AddCoeffs(x1, ShiftedCoeffs(x2,2*n));
    AddCoeffs(x1, ShiftedCoeffs(x3,n));
    return x1;    
end;



KaratsubaTasked := function(f,g)
    local  cf, cg, cr;
    if IsZero(f) or IsZero(g) then 
        return Zero(f);
    fi;
    cf := CoefficientsOfLaurentPolynomial(f);
    cg := CoefficientsOfLaurentPolynomial(g);
    
    cr := KaratsubaTaskedInner(cf[1], cg[1]);
    
    return LaurentPolynomialByCoefficients(CoefficientsFamily(f), cr, cf[2]+cg[2], IndeterminateOfLaurentPolynomial(f));
    
end;

