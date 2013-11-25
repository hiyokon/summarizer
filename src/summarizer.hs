import System.Random
import System.IO

rand :: IO Int
rand = getStdRandom (randomR (0, 1))

randomInt :: RandomGen g => g -> Int
randomInt gen = fst $ random gen

main :: IO ()
main = do
        outputFile <- openFile "../data/data.tsv" WriteMode
        let startTime  = 20131130090000
            intervals  = map (+startTime) [2,4..10000]
            randomvals = take 5000 $ randomRs (1,10) (mkStdGen 99) :: [Int]
            outputList = zipWith (\x y -> show x ++ "\t" ++ show y) intervals randomvals
        hPutStrLn outputFile ("time" ++ "\t" ++ "count")
        mainloop outputList outputFile
        hClose outputFile

mainloop :: [String] -> Handle -> IO ()
mainloop []     _   = return ()
mainloop (x:xs) out = do
                       hPutStrLn out x
                       mainloop xs out

-- newtype State s a = State {
--                     runState :: s -> (a, s)
--                     }
-- 
-- returnState :: a -> State s a
-- returnState a = State $ \s -> (a, s)
-- 
-- bindState :: State s a -> (a -> State s b) -> State s b
-- bindState m k = State $ \s -> let (a, s') = runState m s
--                                   in runState (k a) s'
-- 
-- get :: State s s
-- get = State $ \s -> (s, s)
-- 
-- put :: s -> State s ()
-- put s = State $ \_ -> ((), s)
-- 
-- type RandomState a = State StdGen a
-- 
-- getRandom :: Random a => RandomState a
-- getRandom =
--         get >>= \gen ->
--         let (val, gen') = random gen in
--             put gen' >>
--             return val
