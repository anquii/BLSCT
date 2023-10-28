import Foundation

public struct RangeProof {
    public let Vs: [Data]
    public let Ls: [Data]
    public let Rs: [Data]
    public let A: Data
    public let S: Data
    public let T1: Data
    public let T2: Data
    public let taux: Data
    public let mu: Data
    public let a: Data
    public let b: Data
    public let t: Data

    public init(Vs: [Data], Ls: [Data], Rs: [Data], A: Data, S: Data, T1: Data, T2: Data, taux: Data, mu: Data, a: Data, b: Data, t: Data) {
        self.Vs = Vs
        self.Ls = Ls
        self.Rs = Rs
        self.A = A
        self.S = S
        self.T1 = T1
        self.T2 = T2
        self.taux = taux
        self.mu = mu
        self.a = a
        self.b = b
        self.t = t
    }
}
