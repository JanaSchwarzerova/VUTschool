function DDP(A,B, AB)

A = sort(A);
B = sort(B);

A = cumsum(A);
B = cumsum(B);

C = [A B];
C = sort(unique(C));
sort_C = C;
C = diff(C);
diff_C = C;
C = sort(C);

disp(['Mapa pozic A: ' num2str([0 A])])
disp(['Mapa pozic B: ' num2str([0 B])])
disp(['Intervalová pozice: ' num2str([0 sort_C])])
disp(['Diference: ' num2str(diff_C)])

if length(AB) == length(C)
    if AB == C
    disp('Možné øešení a reverzibilní: Korespondují')
    end
else
    disp('Možné øešení a reverzibilní: Nekorespondují')
end