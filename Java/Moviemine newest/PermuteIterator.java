import java.util.*;

class PermutationIterator <T> implements Iterator <List <T>> {

    private int  current = 0;
    private final long last;
    private final List <T> lilio;
    
    public PermutationIterator (final List <T> llo) {
        lilio = llo;
        long product = 1;
        for (long p = 1; p <= llo.size (); ++p) 
            product *= p; 
        last = product;
    }

    public boolean hasNext () {
        return current != last;
    }

    public List <T> next () {
        ++current;
        return get (current - 1, lilio);
    }

    public void remove () {
        ++current;
    }

    private List <T> get (final int code, final List <T> li) {
        int len = li.size ();
        int pos = code % len;
        if (len > 1) {
            List <T> rest = get (code / len, li.subList (1, li.size ()));
            List <T> a = rest.subList (0, pos);
            List <T> res = new ArrayList <T> ();
            res.addAll (a);
            res.add (li.get (0));
            res.addAll (rest.subList (pos, rest.size ()));
            return res;
        }
        return li;
    }
}

class PermutationIterable <T> implements Iterable <List <T>> {

    private List <T> lilio; 

    public PermutationIterable (List <T> llo) {
        lilio = llo;
    }

    public Iterator <List <T>> iterator () {
        return new PermutationIterator <T> (lilio);
    }
}

class PermutationIteratorTest {

    public static void main (String[] args) {
        List <Integer> la = Arrays.asList (new Integer [] {1, 3, 14});
        PermutationIterable <Integer> pi = new PermutationIterable <Integer> (la);
        for (List <Integer> lc: pi)
            show (lc);
    }

    public static void show (List <Integer> lo) {
        System.out.print ("(");
        for (Object o: lo)
            System.out.print (o + ", ");
        System.out.println (")");
    }
}