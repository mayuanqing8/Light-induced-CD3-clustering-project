function  y=pearson_coef(m, n)

y=sum((m-mean(m)).*(n-mean(n)))/...
    sqrt(sum((m-mean(m)).^2)*sum((n-mean(n)).^2));
end

